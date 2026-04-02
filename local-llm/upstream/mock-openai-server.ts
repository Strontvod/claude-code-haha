const PORT = Number(process.env.LOCAL_LLM_UPSTREAM_PORT || 8080)
const MODEL_ID = process.env.LOCAL_LLM_MODEL || 'local-dev-model'

type OpenAIChatCompletionRequest = {
  model?: string
  messages?: Array<{ role?: string; content?: string }>
  max_tokens?: number
}

Bun.serve({
  port: PORT,
  async fetch(req) {
    const url = new URL(req.url)
    if (req.method === 'GET' && url.pathname === '/health') {
      return Response.json({
        ok: true,
        provider: 'mock-openai',
        model: MODEL_ID,
        port: PORT,
      })
    }

    if (req.method === 'GET' && url.pathname === '/v1/models') {
      return Response.json({
        object: 'list',
        data: [
          {
            id: MODEL_ID,
            object: 'model',
            created: Math.floor(Date.now() / 1000),
            owned_by: 'local',
          },
        ],
      })
    }

    if (req.method === 'POST' && url.pathname === '/v1/chat/completions') {
      let body: OpenAIChatCompletionRequest
      try {
        body = (await req.json()) as OpenAIChatCompletionRequest
      } catch {
        return new Response(JSON.stringify({ error: 'invalid json' }), {
          status: 400,
          headers: { 'content-type': 'application/json' },
        })
      }

      const lastUser = [...(body.messages || [])]
        .reverse()
        .find(msg => msg.role === 'user')
      const userText = (lastUser?.content || '').trim()
      const outputText = userText
        ? `LOCAL_OK: ${userText}`
        : 'LOCAL_OK: mock upstream is running'

      return Response.json({
        id: `chatcmpl_${crypto.randomUUID().replace(/-/g, '')}`,
        object: 'chat.completion',
        created: Math.floor(Date.now() / 1000),
        model: body.model || MODEL_ID,
        choices: [
          {
            index: 0,
            finish_reason: 'stop',
            message: {
              role: 'assistant',
              content: outputText,
            },
          },
        ],
        usage: {
          prompt_tokens: 10,
          completion_tokens: 10,
          total_tokens: 20,
        },
      })
    }

    return new Response('Not Found', { status: 404 })
  },
})

console.log(
  `[local-llm mock-upstream] listening on http://127.0.0.1:${PORT} model=${MODEL_ID}`,
)
