import { describe, expect, test } from 'bun:test'

import {
  assertIsolatedClaudeConfigDir,
  detectClaudeHahaProviderMode,
  getDefaultClaudeHahaConfigDir,
} from './claudeHahaConfig.js'

describe('claudeHahaConfig', () => {
  test('defaults to an isolated claude-haha config directory', () => {
    expect(getDefaultClaudeHahaConfigDir('C:\\Users\\schep')).toBe(
      'C:\\Users\\schep\\.claude-haha',
    )
  })

  test('rejects the official global claude config directory', () => {
    expect(() =>
      assertIsolatedClaudeConfigDir(
        'C:\\Users\\schep\\.claude',
        'C:\\Users\\schep',
      ),
    ).toThrow(/\.claude-haha/)
  })

  test('detects the Fireworks GLM-5 provider mode from the base url', () => {
    expect(
      detectClaudeHahaProviderMode({
        ANTHROPIC_BASE_URL: 'https://api.fireworks.ai/inference',
      }),
    ).toBe('fireworks')
  })

  test('detects the local proxy provider mode from the base url', () => {
    expect(
      detectClaudeHahaProviderMode({
        ANTHROPIC_BASE_URL: 'http://127.0.0.1:4000',
      }),
    ).toBe('local-proxy')
  })
})
