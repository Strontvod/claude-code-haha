import path from 'node:path'

export type ClaudeHahaProviderMode =
  | 'anthropic-default'
  | 'fireworks'
  | 'openrouter'
  | 'local-proxy'
  | 'third-party-compatible'

function normalizePathForComparison(input: string): string {
  return path.normalize(input).replace(/[\\/]+$/, '').toLowerCase()
}

export function getDefaultClaudeHahaConfigDir(homeDir: string): string {
  return path.join(homeDir, '.claude-haha')
}

export function isOfficialClaudeConfigDir(
  configDir: string,
  homeDir: string,
): boolean {
  return (
    normalizePathForComparison(configDir) ===
    normalizePathForComparison(path.join(homeDir, '.claude'))
  )
}

export function assertIsolatedClaudeConfigDir(
  configDir: string,
  homeDir: string,
): void {
  if (isOfficialClaudeConfigDir(configDir, homeDir)) {
    throw new Error(
      'claude-haha must use an isolated config directory under ~/.claude-haha and must not point at the official ~/.claude directory.',
    )
  }
}

export function detectClaudeHahaProviderMode(env: {
  ANTHROPIC_BASE_URL?: string
}): ClaudeHahaProviderMode {
  const baseUrl = env.ANTHROPIC_BASE_URL?.trim()
  if (!baseUrl) {
    return 'anthropic-default'
  }

  try {
    const url = new URL(baseUrl)
    const host = url.host.toLowerCase()

    if (host === 'api.fireworks.ai') {
      return 'fireworks'
    }

    if (host === 'openrouter.ai') {
      return 'openrouter'
    }

    if (
      (host === '127.0.0.1:4000' || host === 'localhost:4000') &&
      url.protocol === 'http:'
    ) {
      return 'local-proxy'
    }

    return 'third-party-compatible'
  } catch {
    return 'third-party-compatible'
  }
}
