import { getSessionId } from '../../bootstrap/state.js'
import { getOauthAccountInfo } from '../../utils/auth.js'
import { getOrCreateUserID } from '../../utils/config.js'
import { logForDebugging } from '../../utils/debug.js'
import { safeParseJSON } from '../../utils/json.js'
import { isFirstPartyAnthropicBaseUrl } from '../../utils/model/providers.js'
import { jsonStringify } from '../../utils/slowOperations.js'

type JsonValue = string | number | boolean | null | JsonObject | JsonArray
type JsonObject = { [key: string]: JsonValue }
type JsonArray = JsonValue[]

/**
 * @see claude.ts getExtraBodyParams — same JsonObject shape for metadata extras.
 */
export function getAPIMetadata(): { user_id: string } {
  let extra: JsonObject = {}
  const extraStr = process.env.CLAUDE_CODE_EXTRA_METADATA
  if (extraStr) {
    const parsed = safeParseJSON(extraStr, false)
    if (parsed && typeof parsed === 'object' && !Array.isArray(parsed)) {
      extra = parsed as JsonObject
    } else {
      logForDebugging(
        `CLAUDE_CODE_EXTRA_METADATA env var must be a JSON object, but was given ${extraStr}`,
        { level: 'error' },
      )
    }
  }

  return {
    user_id: jsonStringify({
      ...extra,
      device_id: getOrCreateUserID(),
      account_uuid: getOauthAccountInfo()?.accountUuid ?? '',
      session_id: getSessionId(),
    }),
  }
}

/**
 * Anthropic-only: `metadata.user_id` shape confuses some Anthropic-compatible
 * APIs (e.g. Fireworks) and can surface as LiteLLM 500 Internal error.
 */
export function getMessagesAPIMetadata():
  | ReturnType<typeof getAPIMetadata>
  | undefined {
  if (!isFirstPartyAnthropicBaseUrl()) {
    return undefined
  }
  return getAPIMetadata()
}
