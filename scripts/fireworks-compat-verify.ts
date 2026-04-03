/**
 * Automated checks for Anthropic-compatible (Fireworks) request shaping.
 * Uses dynamic imports so ANTHROPIC_BASE_URL is set before modules load caches.
 *
 * Run from repo root: bun run scripts/fireworks-compat-verify.ts
 */
async function main(): Promise<void> {
  const failures: string[] = []
  const saved: Record<string, string | undefined> = {
    ANTHROPIC_BASE_URL: process.env.ANTHROPIC_BASE_URL,
    ANTHROPIC_API_KEY: process.env.ANTHROPIC_API_KEY,
    ENABLE_TOOL_SEARCH: process.env.ENABLE_TOOL_SEARCH,
    CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS:
      process.env.CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS,
    CLAUDE_CODE_EXTRA_BODY: process.env.CLAUDE_CODE_EXTRA_BODY,
  }

  process.env.ANTHROPIC_BASE_URL = 'https://api.fireworks.ai/inference'
  process.env.ANTHROPIC_API_KEY = 'fw_test_key'
  process.env.ENABLE_TOOL_SEARCH = 'true'
  delete process.env.CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS
  delete process.env.CLAUDE_CODE_EXTRA_BODY

  try {
    const { isFirstPartyAnthropicBaseUrl } = await import(
      '../src/utils/model/providers.js'
    )
    if (isFirstPartyAnthropicBaseUrl()) {
      failures.push(
        'isFirstPartyAnthropicBaseUrl() must be false for api.fireworks.ai',
      )
    }

    const { getToolSearchMode } = await import('../src/utils/toolSearch.js')
    const mode = getToolSearchMode()
    if (mode !== 'standard') {
      failures.push(
        `getToolSearchMode() must be "standard" for Fireworks (got "${mode}")`,
      )
    }

    const { getMergedBetas } = await import('../src/utils/betas.js')
    const betas = getMergedBetas('accounts/fireworks/models/glm-5', {
      isAgenticQuery: true,
    })
    if (betas.length > 0) {
      failures.push(
        `getMergedBetas() must be empty without ANTHROPIC_BETAS (got ${JSON.stringify(betas)})`,
      )
    }

    const { getMessagesAPIMetadata } = await import(
      '../src/services/api/apiMessagesMetadata.js'
    )
    if (getMessagesAPIMetadata() !== undefined) {
      failures.push('getMessagesAPIMetadata() must be undefined for Fireworks')
    }

    const { getExtraBodyParams, getPromptCachingEnabled } = await import(
      '../src/services/api/claude.js'
    )
    const extra = getExtraBodyParams()
    if ('anthropic_beta' in extra || 'anti_distillation' in extra) {
      failures.push(
        `getExtraBodyParams() must not include anthropic_beta / anti_distillation (keys: ${Object.keys(extra).join(',')})`,
      )
    }

    if (getPromptCachingEnabled('accounts/fireworks/models/glm-5')) {
      failures.push('getPromptCachingEnabled() must be false for third-party URL')
    }

    const { modelSupportsThinking, modelSupportsAdaptiveThinking } = await import(
      '../src/utils/thinking.js'
    )
    const m = 'accounts/fireworks/models/glm-5'
    if (modelSupportsThinking(m) || modelSupportsAdaptiveThinking(m)) {
      failures.push(
        'thinking support must be false for Fireworks GLM model id',
      )
    }

    const { modelSupportsEffort } = await import('../src/utils/effort.js')
    if (modelSupportsEffort(m)) {
      failures.push('modelSupportsEffort must be false for Fireworks GLM model id')
    }
  } finally {
    for (const [k, v] of Object.entries(saved)) {
      if (v === undefined) delete process.env[k]
      else process.env[k] = v
    }
  }

  if (failures.length > 0) {
    // biome-ignore lint/suspicious/noConsole: verification script
    console.error(failures.join('\n'))
    process.exit(1)
  }
  // biome-ignore lint/suspicious/noConsole: verification script
  console.log('fireworks-compat-verify: all checks passed')
}

main().catch(err => {
  // biome-ignore lint/suspicious/noConsole: verification script
  console.error(err)
  process.exit(1)
})
