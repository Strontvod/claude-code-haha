type AnthropicTextBlock = {
  type: 'text'
  text: string
}

type AnthropicMessage = {
  role: 'user' | 'assistant'
  content: string | AnthropicTextBlock[]
}

type AnthropicMessagesRequest = {
  model?: string
  max_tokens?: number
  temperature?: number
  system?: string | AnthropicTextBlock[]
  messages?: AnthropicMessage[]
}

const PROXY_PORT = Number(process.env.LOCAL_LLM_PROXY_PORT || 4000)
const UPSTREAM_BASE_URL = (
  process.env.LOCAL_LLM_UPSTREAM || 'http://127.0.0.1:11434'
).replace(/\/+$/, '')
const FALLBACK_MODEL = process.env.LOCAL_LLM_MODEL || 'local-dev-model'
const UPSTREAM_API_KEY = process.env.LOCAL_LLM_UPSTREAM_API_KEY || ''
const UPSTREAM_PROVIDER = (
  process.env.LOCAL_LLM_UPSTREAM_PROVIDER || 'auto'
).toLowerCase()

function textFromContent(
  content: AnthropicMessage['content'] | AnthropicMessagesRequest['system'],
): string {
  if (typeof content === 'string') return content
  if (!Array.isArray(content)) return ''
  return content
    .filter(block => block?.type === 'text')
    .map(block => block.text)
    .join('\n')
}

function jsonError(status: number, message: string): Response {
  return new Response(
    JSON.stringify({
      type: 'error',
      error: {
        type: 'api_error',
        message,
      },
    }),
    {
      status,
      headers: { 'content-type': 'application/json' },
    },
  )
}

async function forwardModels(): Promise<Response> {
  try {
    // OpenAI-compatible upstreams (vLLM, LM Studio, etc.)
    if (UPSTREAM_PROVIDER !== 'ollama') {
      const openAiRes = await fetch(`${UPSTREAM_BASE_URL}/v1/models`)
      if (openAiRes.ok || UPSTREAM_PROVIDER === 'openai') {
        const body = await openAiRes.text()
        return new Response(body, {
          status: openAiRes.status,
          headers: { 'content-type': 'application/json' },
        })
      }
    }

    // Ollama native fallback
    const ollamaRes = await fetch(`${UPSTREAM_BASE_URL}/api/tags`)
    const ollamaJson = await ollamaRes.json()
    const tags = Array.isArray(ollamaJson?.models) ? ollamaJson.models : []
    const mapped = {
      object: 'list',
      data: tags.map((m: any) => ({
        id: m?.name || FALLBACK_MODEL,
        object: 'model',
        created: Math.floor(Date.now() / 1000),
        owned_by: 'ollama',
      })),
    }
    return Response.json(mapped, { status: ollamaRes.status })
  } catch (error) {
    const msg = error instanceof Error ? error.message : String(error)
    return jsonError(500, `Unable to fetch models from upstream: ${msg}`)
  }
}

function buildAnthropicResponse(
  model: string,
  assistantText: string,
  promptTokens = 0,
  completionTokens = 0,
): Response {
  const anthropicResponse = {
    id: `msg_local_${crypto.randomUUID().replace(/-/g, '')}`,
    type: 'message',
    role: 'assistant',
    model,
    content: [
      {
        type: 'text',
        text: assistantText,
      },
    ],
    stop_reason: 'end_turn',
    stop_sequence: null,
    usage: {
      input_tokens: promptTokens,
      output_tokens: completionTokens,
    },
  }
  return new Response(JSON.stringify(anthropicResponse), {
    status: 200,
    headers: { 'content-type': 'application/json' },
  })
}

async function forwardOpenAI(
  model: string,
  messages: Array<{ role: string; content: string }>,
  maxTokens: number,
  temperature: number | undefined,
): Promise<Response> {
  const upstreamHeaders: Record<string, string> = {
    'content-type': 'application/json',
  }
  if (UPSTREAM_API_KEY) {
    upstreamHeaders.Authorization = `Bearer ${UPSTREAM_API_KEY}`
  }

  const upstreamPayload = {
    model,
    messages,
    max_tokens: maxTokens,
    temperature,
    stream: false,
  }

  const upstreamResponse = await fetch(`${UPSTREAM_BASE_URL}/v1/chat/completions`, {
    method: 'POST',
    headers: upstreamHeaders,
    body: JSON.stringify(upstreamPayload),
  })
  const rawText = await upstreamResponse.text()
  if (!upstreamResponse.ok) {
    return new Response(rawText || JSON.stringify({ error: 'Upstream error' }), {
      status: upstreamResponse.status,
      headers: { 'content-type': 'application/json' },
    })
  }
  const upstreamJson = JSON.parse(rawText)
  const assistantText =
    upstreamJson?.choices?.[0]?.message?.content ??
    upstreamJson?.choices?.[0]?.text ??
    ''
  return buildAnthropicResponse(
    model,
    String(assistantText),
    upstreamJson?.usage?.prompt_tokens ?? 0,
    upstreamJson?.usage?.completion_tokens ?? 0,
  )
}

async function forwardOllama(
  model: string,
  messages: Array<{ role: string; content: string }>,
  maxTokens: number,
  temperature: number | undefined,
): Promise<Response> {
  const upstreamPayload = {
    model,
    messages,
    stream: false,
    options: {
      num_predict: maxTokens,
      temperature,
    },
  }
  const upstreamResponse = await fetch(`${UPSTREAM_BASE_URL}/api/chat`, {
    method: 'POST',
    headers: { 'content-type': 'application/json' },
    body: JSON.stringify(upstreamPayload),
  })
  const rawText = await upstreamResponse.text()
  if (!upstreamResponse.ok) {
    return new Response(rawText || JSON.stringify({ error: 'Upstream error' }), {
      status: upstreamResponse.status,
      headers: { 'content-type': 'application/json' },
    })
  }
  const upstreamJson = JSON.parse(rawText)
  const assistantText = String(upstreamJson?.message?.content ?? '')
  return buildAnthropicResponse(model, assistantText)
}

async function forwardMessages(req: Request): Promise<Response> {
  let body: AnthropicMessagesRequest
  try {
    body = (await req.json()) as AnthropicMessagesRequest
  } catch {
    return jsonError(400, 'Invalid JSON body')
  }

  const model = body.model || FALLBACK_MODEL
  const openAiMessages: Array<{ role: string; content: string }> = []
  const systemText = textFromContent(body.system)
  if (systemText) {
    openAiMessages.push({ role: 'system', content: systemText })
  }
  for (const msg of body.messages || []) {
    openAiMessages.push({
      role: msg.role,
      content: textFromContent(msg.content),
    })
  }

  const maxTokens = body.max_tokens ?? 1024
  try {
    if (UPSTREAM_PROVIDER === 'openai') {
      return await forwardOpenAI(model, openAiMessages, maxTokens, body.temperature)
    }
    if (UPSTREAM_PROVIDER === 'ollama') {
      return await forwardOllama(model, openAiMessages, maxTokens, body.temperature)
    }

    // auto mode: try OpenAI first, then Ollama fallback
    const openAiTry = await forwardOpenAI(
      model,
      openAiMessages,
      maxTokens,
      body.temperature,
    )
    if (openAiTry.status !== 404 && openAiTry.status !== 405) {
      return openAiTry
    }
    return await forwardOllama(model, openAiMessages, maxTokens, body.temperature)
  } catch (error) {
    const msg = error instanceof Error ? error.message : String(error)
    return jsonError(
      500,
      `Unable to connect to upstream at ${UPSTREAM_BASE_URL}: ${msg}`,
    )
  }
}

Bun.serve({
  port: PROXY_PORT,
  async fetch(req) {
    const url = new URL(req.url)
    if (req.method === 'GET' && url.pathname === '/health') {
      return Response.json({
        ok: true,
        upstream: UPSTREAM_BASE_URL,
        proxyPort: PROXY_PORT,
        provider: UPSTREAM_PROVIDER,
      })
    }
    if (req.method === 'GET' && url.pathname === '/v1/models') {
      return forwardModels()
    }
    if (req.method === 'POST' && url.pathname === '/v1/messages') {
      return forwardMessages(req)
    }
    return new Response('Method Not Allowed', {
      status: 405,
      headers: { 'content-type': 'text/plain' },
    })
  },
})

console.log(
  `[local-llm proxy] listening on http://127.0.0.1:${PROXY_PORT} -> ${UPSTREAM_BASE_URL} (provider=${UPSTREAM_PROVIDER})`,
)
