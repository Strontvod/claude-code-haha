import { describe, expect, test } from 'bun:test'

import {
  buildLocalUltraplanPrompt,
  LOCAL_ULTRAPLAN_USAGE,
} from './localPrompt.js'

describe('local ultraplan prompt helpers', () => {
  test('describes the local-only slash command usage', () => {
    expect(LOCAL_ULTRAPLAN_USAGE).toContain('Usage: /ultraplan <prompt>')
    expect(LOCAL_ULTRAPLAN_USAGE).toContain('No Claude Code on the web')
  })

  test('builds a local planning prompt with explore/plan guidance', () => {
    const prompt = buildLocalUltraplanPrompt('Add a local ultraplan command.', {
      context: {
        hasExplorePlanAgents: true,
        exploreAgentCount: 3,
        planAgentCount: 2,
      },
    })

    expect(prompt).toContain('Local ultraplan mode is active.')
    expect(prompt).toContain('Do not use Claude Code on the web')
    expect(prompt).toContain('Launch up to 3 Explore agent(s) in parallel')
    expect(prompt).toContain('up to 2 Plan agent(s)')
    expect(prompt).toContain('User request:\nAdd a local ultraplan command.')
  })

  test('supports refining an existing draft without specialized agents', () => {
    const prompt = buildLocalUltraplanPrompt('', {
      seedPlan: '1. Rewrite the command\n2. Keep it local',
      context: {
        hasExplorePlanAgents: false,
        exploreAgentCount: 1,
        planAgentCount: 1,
      },
    })

    expect(prompt).toContain(
      'Refine the existing draft plan below instead of starting from scratch:',
    )
    expect(prompt).toContain('1. Rewrite the command')
    expect(prompt).toContain('specialized Explore/Plan agents may be unavailable')
    expect(prompt).toContain('general-purpose local agents in parallel')
  })
})
