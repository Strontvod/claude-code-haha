import { areExplorePlanAgentsEnabled } from '../../tools/AgentTool/builtInAgents.js'
import {
  getPlanModeV2AgentCount,
  getPlanModeV2ExploreAgentCount,
} from '../planModeV2.js'

export type LocalUltraplanPromptContext = {
  hasExplorePlanAgents: boolean
  exploreAgentCount: number
  planAgentCount: number
}

export const LOCAL_ULTRAPLAN_USAGE = [
  'Usage: /ultraplan <prompt>',
  '',
  'Runs a stronger local planning pass inside claude-haha.',
  'No Claude Code on the web, no teleport, and no remote session.',
  'Claude stays in this local session, explores locally, and writes/refines the session plan file.',
].join('\n')

export const LOCAL_ULTRAPLAN_LAUNCH_MESSAGE =
  'Enabled local ultraplan mode. Claude will continue planning in this local session.'

export function getLocalUltraplanPromptContext(): LocalUltraplanPromptContext {
  return {
    hasExplorePlanAgents: areExplorePlanAgentsEnabled(),
    exploreAgentCount: getPlanModeV2ExploreAgentCount(),
    planAgentCount: getPlanModeV2AgentCount(),
  }
}

export function buildLocalUltraplanPrompt(
  blurb: string,
  opts: {
    seedPlan?: string
    context?: LocalUltraplanPromptContext
  } = {},
): string {
  const context = opts.context ?? getLocalUltraplanPromptContext()
  const sections: string[] = []

  if (opts.seedPlan) {
    sections.push(
      'Refine the existing draft plan below instead of starting from scratch:',
      '',
      opts.seedPlan,
    )
  }

  const workflowSection = context.hasExplorePlanAgents
    ? [
        'Use the local planning stack aggressively.',
        `Launch up to ${context.exploreAgentCount} Explore agent(s) in parallel for discovery, then up to ${context.planAgentCount} Plan agent(s) to pressure-test the implementation approach.`,
        'Prefer different investigation angles when using multiple agents: reuse existing code, edge cases, testing/verification, and migration risk.',
      ].join('\n')
    : [
        'The specialized Explore/Plan agents may be unavailable in this build.',
        'Compensate by doing deeper local exploration yourself and, when helpful, launching multiple general-purpose local agents in parallel.',
      ].join('\n')

  sections.push(
    [
      'Local ultraplan mode is active.',
      'Stay fully local inside this claude-haha session.',
      'Do not use Claude Code on the web, teleport, remote sessions, remote agents, or /login.',
      'Treat this as a higher-effort planning pass than a normal /plan request.',
      '',
      workflowSection,
      '',
      'Before you finish, the plan file should cover:',
      '- the user goal, scope, and constraints',
      '- existing code paths, helpers, and symbols worth reusing',
      '- the exact files likely to change',
      '- risks, edge cases, trade-offs, and fallback decisions',
      '- a concrete verification plan',
      '',
      'Ask clarifying questions only if they materially change the design.',
      'Do not implement yet; stay in planning mode until the plan is ready for approval.',
    ].join('\n'),
  )

  if (blurb) {
    sections.push(`User request:\n${blurb}`)
  }

  return sections.join('\n\n')
}
