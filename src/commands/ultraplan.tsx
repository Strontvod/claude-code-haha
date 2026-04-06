import { handlePlanModeTransition } from '../bootstrap/state.js'
import type { Command } from '../commands.js'
import type { AppState } from '../state/AppStateStore.js'
import type { LocalJSXCommandCall } from '../types/command.js'
import { createUserMessage } from '../utils/messages.js'
import { applyPermissionUpdate } from '../utils/permissions/PermissionUpdate.js'
import { prepareContextForPlanMode } from '../utils/permissions/permissionSetup.js'
import {
  buildLocalUltraplanPrompt,
  getLocalUltraplanPromptContext,
  LOCAL_ULTRAPLAN_LAUNCH_MESSAGE,
  LOCAL_ULTRAPLAN_USAGE,
} from '../utils/ultraplan/localPrompt.js'

type SetAppState = (fn: (prev: AppState) => AppState) => void

function ensurePlanMode(
  getAppState: () => AppState,
  setAppState: SetAppState,
): void {
  const currentMode = getAppState().toolPermissionContext.mode

  if (currentMode === 'plan') {
    return
  }

  handlePlanModeTransition(currentMode, 'plan')
  setAppState(prev => ({
    ...prev,
    toolPermissionContext: applyPermissionUpdate(
      prepareContextForPlanMode(prev.toolPermissionContext),
      {
        type: 'setMode',
        mode: 'plan',
        destination: 'session',
      },
    ),
  }))
}

export async function launchUltraplan(opts: {
  blurb: string
  seedPlan?: string
  getAppState: () => AppState
  setAppState: SetAppState
  signal?: AbortSignal
  disconnectedBridge?: boolean
  onSessionReady?: (msg: string) => void
}): Promise<string> {
  const { blurb, seedPlan, getAppState, setAppState } = opts

  if (!blurb && !seedPlan) {
    return LOCAL_ULTRAPLAN_USAGE
  }

  ensurePlanMode(getAppState, setAppState)

  const prompt = buildLocalUltraplanPrompt(blurb, {
    seedPlan,
    context: getLocalUltraplanPromptContext(),
  })

  setAppState(prev => ({
    ...prev,
    initialMessage: {
      message: createUserMessage({
        content: prompt,
      }),
      mode: 'plan',
    },
  }))

  return LOCAL_ULTRAPLAN_LAUNCH_MESSAGE
}

const call: LocalJSXCommandCall = async (onDone, context, args) => {
  const blurb = args.trim()

  if (!blurb) {
    onDone(LOCAL_ULTRAPLAN_USAGE, { display: 'system' })
    return null
  }

  ensurePlanMode(context.getAppState, context.setAppState)

  const prompt = buildLocalUltraplanPrompt(blurb, {
    context: getLocalUltraplanPromptContext(),
  })

  onDone(LOCAL_ULTRAPLAN_LAUNCH_MESSAGE, {
    display: 'system',
    shouldQuery: true,
    metaMessages: [prompt],
  })

  return null
}

export default {
  type: 'local-jsx',
  name: 'ultraplan',
  description:
    'Local-only intensive planning pass that stays inside claude-haha and writes a stronger plan.',
  argumentHint: '<prompt>',
  load: () => Promise.resolve({ call }),
} satisfies Command
