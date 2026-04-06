[Skip to content](https://github.com/cline/cline/issues/4371#start-of-content)

You signed in with another tab or window. [Reload](https://github.com/cline/cline/issues/4371) to refresh your session.You signed out in another tab or window. [Reload](https://github.com/cline/cline/issues/4371) to refresh your session.You switched accounts on another tab or window. [Reload](https://github.com/cline/cline/issues/4371) to refresh your session.Dismiss alert

{{ message }}

[cline](https://github.com/cline)/ **[cline](https://github.com/cline/cline)** Public

- [Notifications](https://github.com/login?return_to=%2Fcline%2Fcline) You must be signed in to change notification settings
- [Fork\\
6.1k](https://github.com/login?return_to=%2Fcline%2Fcline)
- [Star\\
59.9k](https://github.com/login?return_to=%2Fcline%2Fcline)


# OpenRouter Provider Selection and Routing\#4371

[New issue](https://github.com/login?return_to=https://github.com/cline/cline/issues/4371)

Copy link

[New issue](https://github.com/login?return_to=https://github.com/cline/cline/issues/4371)

Copy link

Closed

Closed

[OpenRouter Provider Selection and Routing](https://github.com/cline/cline/issues/4371#top)#4371

Copy link

Labels

[Bot RespondedIssue has received an automated response](https://github.com/cline/cline/issues?q=state%3Aopen%20label%3A%22Bot%20Responded%22) Issue has received an automated response [Help WantedCommunity contributions welcome](https://github.com/cline/cline/issues?q=state%3Aopen%20label%3A%22Help%20Wanted%22) Community contributions welcome

[![@celestial-vault](https://avatars.githubusercontent.com/u/58194240?u=9b25d0ee2efcc7ba71bfa2f95b5b7eb904d3b45c&v=4&size=80)](https://github.com/celestial-vault)

## Description

[![@celestial-vault](https://avatars.githubusercontent.com/u/58194240?u=9b25d0ee2efcc7ba71bfa2f95b5b7eb904d3b45c&v=4&size=48)](https://github.com/celestial-vault)

[celestial-vault](https://github.com/celestial-vault)

opened [on Jun 21, 2025on Jun 21, 2025](https://github.com/cline/cline/issues/4371#issue-3165486658)

Contributor

Issue body actions

## Problem

OpenRouter's dynamic load balancing causes inconsistent behavior when models are served by multiple providers with different capabilities:

- **Qwen2.5 Coder 32B Instruct** providers:
  - DeepInfra: 33k context
  - Hyperbolic: 128k context
  - Fireworks: 33k context
- **DeepSeek R1** providers:
  - Different speeds and reliability (DeepInfra vs inference.net)

Users experience unpredictable performance due to random provider routing, especially with context window limitations and provider-specific optimizations.

Current workarounds are insufficient:

- Banning providers at OpenRouter level doesn't fix Cline showing lowest context limit
- Users need direct control over provider selection within Cline

## Solution

Complete the existing OpenRouter provider routing implementation:

1. **UI/UX for Provider Selection** \- Add interface for users to specify preferred providers
2. **Provider Autocomplete** \- Fetch available providers from OpenRouter API for validation
3. **Fallback Configuration** \- Allow users to set provider preference order
4. **Context Window Detection** \- Use actual provider context limits instead of minimum

The backend infrastructure already exists via parameter.

## Related Issues

- Closes [Add ability to choose preferred provider on OpenRouter #737](https://github.com/cline/cline/issues/737) \- Add ability to choose preferred provider on OpenRouter (20 👍, 16 comments)
- Closes [More specific openrouter provider sorting #4349](https://github.com/cline/cline/issues/4349) \- More specific openrouter provider sorting (detailed implementation)
- Related to [Qwen 23B coder (new) delivers garbage when used with Cline #722](https://github.com/cline/cline/issues/722) \- Qwen model inconsistencies (consolidated into [Improve Ollama Local Model Compatibility #4362](https://github.com/cline/cline/issues/4362))

👍React with 👍3HisMaj3sty, boriselec and znissou

## Activity

[![](https://avatars.githubusercontent.com/u/58194240?s=64&u=9b25d0ee2efcc7ba71bfa2f95b5b7eb904d3b45c&v=4)celestial-vault](https://github.com/celestial-vault)

mentioned this in 2 issues [on Jun 21, 2025on Jun 21, 2025](https://github.com/cline/cline/issues/4371#event-2651362624)

- [Add ability to choose preferred provider on OpenRouter #737](https://github.com/cline/cline/issues/737)

- [More specific openrouter provider sorting #4349](https://github.com/cline/cline/issues/4349)


[![](https://avatars.githubusercontent.com/u/58194240?s=64&u=9b25d0ee2efcc7ba71bfa2f95b5b7eb904d3b45c&v=4)celestial-vault](https://github.com/celestial-vault)

added

[proposal](https://github.com/cline/cline/issues?q=state%3Aopen%20label%3A%22proposal%22)

[on Jun 21, 2025on Jun 21, 2025](https://github.com/cline/cline/issues/4371#event-18259112872)

[![](https://avatars.githubusercontent.com/u/58194240?s=64&u=9b25d0ee2efcc7ba71bfa2f95b5b7eb904d3b45c&v=4)celestial-vault](https://github.com/celestial-vault)

mentioned this [on Jun 21, 2025on Jun 21, 2025](https://github.com/cline/cline/issues/4371#event-2651364412)

- [400 error #1082](https://github.com/cline/cline/issues/1082)


[![kedihacker](https://avatars.githubusercontent.com/u/68711696?u=4f13829fd4c23e60154f680c680dfb750d99646c&v=4&size=80)](https://github.com/kedihacker)

### kedihacker commented on Jun 22, 2025on Jun 22, 2025

[![@kedihacker](https://avatars.githubusercontent.com/u/68711696?u=4f13829fd4c23e60154f680c680dfb750d99646c&v=4&size=48)](https://github.com/kedihacker)

[kedihacker](https://github.com/kedihacker)

[on Jun 22, 2025on Jun 22, 2025](https://github.com/cline/cline/issues/4371#issuecomment-2994087621)

More actions

I would like to develop this. I need detailed guidance on UI/UX to development.

[![arafatkatze](https://avatars.githubusercontent.com/u/11155207?u=cd4d7ee51cdd943f2bc1445788062f25a8dd3dcb&v=4&size=80)](https://github.com/arafatkatze)

### arafatkatze commented on Jun 22, 2025on Jun 22, 2025

[![@arafatkatze](https://avatars.githubusercontent.com/u/11155207?u=cd4d7ee51cdd943f2bc1445788062f25a8dd3dcb&v=4&size=48)](https://github.com/arafatkatze)

[arafatkatze](https://github.com/arafatkatze)

[on Jun 22, 2025on Jun 22, 2025](https://github.com/cline/cline/issues/4371#issuecomment-2994102505)

Contributor

More actions

[@kedihacker](https://github.com/kedihacker) [@celestial-vault](https://github.com/celestial-vault) the best way to set a preferred provider is to first fetch the list of available providers and then in the UX have a selector option where it says preferred provider which is set to default(meaning that no provider is specifically given a preference except for the one that openrouter automagically decides).

Now when use clicks on that selector they can click on specific provider that they prefer and then that provider will be used with a fallback incase that specific provider is down( [see docs](https://openrouter.ai/docs/features/provider-routing#example-specifying-providers-with-fallbacks)).

This removes slightly confusing UX concepts like preferred provider ordering because I doubt most users would care about the preferential ordering between multiple providers but they might have a personal favorite which will be selected by this and on the off chance that it isn't available openrouter automagically falls back to the next best thing.

[@kedihacker](https://github.com/kedihacker) This should be enough to get you started on a PR for this and the docs of openrouter can help you figure out the rest.

[![realchrisolin](https://avatars.githubusercontent.com/u/1288116?u=9cd46204079272f65d10f774fa457bf7de0a6cb0&v=4&size=80)](https://github.com/realchrisolin)

### realchrisolin commented on Jun 22, 2025on Jun 22, 2025

[![@realchrisolin](https://avatars.githubusercontent.com/u/1288116?u=9cd46204079272f65d10f774fa457bf7de0a6cb0&v=4&size=48)](https://github.com/realchrisolin)

[realchrisolin](https://github.com/realchrisolin)

[on Jun 22, 2025on Jun 22, 2025](https://github.com/cline/cline/issues/4371#issuecomment-2994612802)

More actions

[@kedihacker](https://github.com/kedihacker) I believe you can gain some insight from Roo Code's implementation [RooCodeInc/Roo-Code@ `eb74f02`](https://github.com/RooCodeInc/Roo-Code/commit/eb74f020945aa380f68c5e7c32958e21b3231253)

[![kedihacker](https://avatars.githubusercontent.com/u/68711696?u=4f13829fd4c23e60154f680c680dfb750d99646c&v=4&size=80)](https://github.com/kedihacker)

### kedihacker commented on Jun 23, 2025on Jun 23, 2025

[![@kedihacker](https://avatars.githubusercontent.com/u/68711696?u=4f13829fd4c23e60154f680c680dfb750d99646c&v=4&size=48)](https://github.com/kedihacker)

[kedihacker](https://github.com/kedihacker)

[on Jun 23, 2025on Jun 23, 2025](https://github.com/cline/cline/issues/4371#issuecomment-2995682015)

More actions

On webview-ui/src/App.tsx:41 41:22 error Don't use `Boolean` as a type. Use boolean instead @typescript-eslint/ban-types error is given when I commit. How should I go about it. [`0c30612`#diff-319593b8c6a997ae0352f2f97feb5888973ab2b7db6ec6d4db75926692e739a8R40](https://github.com/cline/cline/commit/0c306121aad2c6c9c4c27e8e41a6c2d40ddcc41f#diff-319593b8c6a997ae0352f2f97feb5888973ab2b7db6ec6d4db75926692e739a8R40)

[![kedihacker](https://avatars.githubusercontent.com/u/68711696?u=4f13829fd4c23e60154f680c680dfb750d99646c&v=4&size=80)](https://github.com/kedihacker)

### kedihacker commented on Jun 23, 2025on Jun 23, 2025

[![@kedihacker](https://avatars.githubusercontent.com/u/68711696?u=4f13829fd4c23e60154f680c680dfb750d99646c&v=4&size=48)](https://github.com/kedihacker)

[kedihacker](https://github.com/kedihacker)

[on Jun 23, 2025on Jun 23, 2025](https://github.com/cline/cline/issues/4371#issuecomment-2997071026)

More actions

Needed to run npm run protos.

👍React with 👍1arafatkatze

[![kedihacker](https://avatars.githubusercontent.com/u/68711696?u=4f13829fd4c23e60154f680c680dfb750d99646c&v=4&size=80)](https://github.com/kedihacker)

### kedihacker commented on Jun 25, 2025on Jun 25, 2025

[![@kedihacker](https://avatars.githubusercontent.com/u/68711696?u=4f13829fd4c23e60154f680c680dfb750d99646c&v=4&size=48)](https://github.com/kedihacker)

[kedihacker](https://github.com/kedihacker)

[on Jun 25, 2025on Jun 25, 2025](https://github.com/cline/cline/issues/4371#issuecomment-3005113091)

More actions

I can't do it but I will reset my fork and try again with a better understanding of the whole thing. If you want to do it just ping me and start implementation

[![](https://avatars.githubusercontent.com/u/11155207?s=64&u=cd4d7ee51cdd943f2bc1445788062f25a8dd3dcb&v=4)arafatkatze](https://github.com/arafatkatze)

mentioned this [on Jul 7, 2025on Jul 7, 2025](https://github.com/cline/cline/issues/4371#event-2723475315)

- [Adding Thinking Token Config to Gemini 2.5 pro model and adding gemini 2.5 flash preview #4668](https://github.com/cline/cline/pull/4668)


[![](https://avatars.githubusercontent.com/u/7799382?s=64&u=c78c6806a4c73fac6b2071bbafcccd8ae54ed055&v=4)saoudrizwan](https://github.com/saoudrizwan)

removed

[proposal](https://github.com/cline/cline/issues?q=state%3Aopen%20label%3A%22proposal%22)

[on Jul 26, 2025on Jul 26, 2025](https://github.com/cline/cline/issues/4371#event-18833539550)

[![vlebert](https://avatars.githubusercontent.com/u/49779177?v=4&size=80)](https://github.com/vlebert)

### vlebert commented on Sep 2, 2025on Sep 2, 2025

[![@vlebert](https://avatars.githubusercontent.com/u/49779177?v=4&size=48)](https://github.com/vlebert)

[vlebert](https://github.com/vlebert)

[on Sep 2, 2025on Sep 2, 2025](https://github.com/cline/cline/issues/4371#issuecomment-3246879115)

More actions

In openrouter it is possible to define a preset at the user level.

In preset you can force provider selection

Presets can be used like a model name. A simple approach would be to allow typing a preset name in the openrouter model dialogbox (i mean accepting text values which are not in the select menu list)

[![github-actions](https://avatars.githubusercontent.com/in/15368?v=4&size=80)](https://github.com/apps/github-actions)

### github-actions commented on Dec 22, 2025on Dec 22, 2025

[![@github-actions](https://avatars.githubusercontent.com/in/15368?v=4&size=48)](https://github.com/apps/github-actions)

[github-actions](https://github.com/apps/github-actions) bot

[on Dec 22, 2025on Dec 22, 2025](https://github.com/cline/cline/issues/4371#issuecomment-3680590392) – with [GitHub Actions](https://help.github.com/en/actions)

Contributor

More actions

## Summary

This is a well-documented feature request to complete the OpenRouter provider selection implementation. The issue consolidates [#737](https://github.com/cline/cline/issues/737) (20 👍) and [#4349](https://github.com/cline/cline/issues/4349).

## Current State

Good news: Cline already has **partial** infrastructure for provider routing:

1. **`openRouterProviderSorting`** field in `ApiConfiguration` (`src/shared/api.ts:98`) \- supports sorting by `price`, `throughput`, or `latency`
2. **UI dropdown** in the Advanced section of Model Info (`webview-ui/src/components/settings/common/ModelInfoView.tsx:298-326`)
3. **Hardcoded provider preferences** for specific models in `OPENROUTER_PROVIDER_PREFERENCES` (`src/shared/api.ts:820-904`) \- currently covers exacto models, Qwen3, DeepSeek, GLM, and Kimi models
4. **Backend wiring** in `openrouter-stream.ts:185-207` that applies these preferences to API requests

What's **missing** for this feature request:

- UI to select a **specific provider** (DeepInfra vs Hyperbolic vs Fireworks)
- Fetching available providers from OpenRouter's API for the selected model
- Using the actual provider's context window instead of the minimum across all providers

## Workarounds

1. **OpenRouter Presets** (as [@vlebert](https://github.com/vlebert) mentioned): You can create a [preset on OpenRouter](https://openrouter.ai/settings/presets) that forces specific providers, then type that preset name in Cline's model field
2. **Provider banning** on OpenRouter: Go to [OpenRouter preferences](https://openrouter.ai/settings/preferences) and ban unwanted providers - though as noted, Cline may still show the lowest context limit
3. **LLM API Gateway** by [@fabiojbg](https://github.com/fabiojbg): [github.com/fabiojbg/LLMApiGateway](https://github.com/fabiojbg/LLMApiGateway) \- a local proxy that injects provider ordering

## For Contributors

[@kedihacker](https://github.com/kedihacker) mentioned wanting to work on this. The key implementation points:

1. Add `openRouterSpecificProvider?: string` to `ApiHandlerOptions` in `src/shared/api.ts`
2. Add state storage in `src/shared/storage/state-keys.ts`
3. Create a provider selector dropdown in `OpenRouterModelPicker.tsx` \- can fetch available providers from OpenRouter's model endpoint (the model data already includes `architecture.instruct_type` and provider info)
4. Wire the selection through to `createOpenRouterStream()` in `src/core/api/transform/openrouter-stream.ts:205-207` using OpenRouter's [provider routing docs](https://openrouter.ai/docs/features/provider-routing)

The Roo Code implementation at [this commit](https://github.com/RooCodeInc/Roo-Code/commit/eb74f020945aa380f68c5e7c32958e21b3231253) provides a reference approach.

## Regression Analysis

I analyzed recent PRs and releases but didn't find any changes that seem related to this issue - this is a feature request rather than a regression.

| SME | Reason |
| --- | --- |
| [@arafatkatze](https://github.com/arafatkatze) | Provided initial UX guidance in comments |
| [@celestial-vault](https://github.com/celestial-vault) | Issue author and contributor to OpenRouter-related code |
| [@saoudrizwan](https://github.com/saoudrizwan) | Primary contributor to API configuration code |

## Possible Duplicates

- [Add ability to choose preferred provider on OpenRouter #737](https://github.com/cline/cline/issues/737) \- "Add ability to choose preferred provider on OpenRouter" (closed, consolidated into this issue)
- [More specific openrouter provider sorting #4349](https://github.com/cline/cline/issues/4349) \- "More specific openrouter provider sorting" (closed, consolidated into this issue)

No other obvious duplicates found.

[![](https://avatars.githubusercontent.com/in/15368?s=64&v=4)github-actions](https://github.com/apps/github-actions)

added

[enhancement](https://github.com/cline/cline/issues?q=state%3Aopen%20label%3A%22enhancement%22)

[Help WantedCommunity contributions welcome](https://github.com/cline/cline/issues?q=state%3Aopen%20label%3A%22Help%20Wanted%22) Community contributions welcome

[Bot RespondedIssue has received an automated response](https://github.com/cline/cline/issues?q=state%3Aopen%20label%3A%22Bot%20Responded%22) Issue has received an automated response

[on Dec 22, 2025on Dec 22, 2025](https://github.com/cline/cline/issues/4371#event-21697275899)

[![linear](https://avatars.githubusercontent.com/in/20150?v=4&size=80)](https://github.com/apps/linear)

### linear commented on Dec 22, 2025on Dec 22, 2025

[![@linear](https://avatars.githubusercontent.com/in/20150?v=4&size=48)](https://github.com/apps/linear)

[linear](https://github.com/apps/linear) bot

[on Dec 22, 2025on Dec 22, 2025](https://github.com/cline/cline/issues/4371#issuecomment-3680590627) – with [Linear](https://linear.app/)

More actions

[CLINE-880](https://linear.app/cline-bot/issue/CLINE-880/openrouter-provider-selection-and-routing)

[![](https://avatars.githubusercontent.com/u/7799382?s=64&u=c78c6806a4c73fac6b2071bbafcccd8ae54ed055&v=4)saoudrizwan](https://github.com/saoudrizwan)

removed

[enhancement](https://github.com/cline/cline/issues?q=state%3Aopen%20label%3A%22enhancement%22)

[on Dec 22, 2025on Dec 22, 2025](https://github.com/cline/cline/issues/4371#event-21712297968)

[![ClineXDiego](https://avatars.githubusercontent.com/u/247419485?v=4&size=80)](https://github.com/ClineXDiego)

### ClineXDiego commented on Mar 3on Mar 3, 2026

[![@ClineXDiego](https://avatars.githubusercontent.com/u/247419485?v=4&size=48)](https://github.com/ClineXDiego)

[ClineXDiego](https://github.com/ClineXDiego)

[on Mar 3on Mar 3, 2026](https://github.com/cline/cline/issues/4371#issuecomment-3993471537)

Contributor

More actions

Closing this umbrella enhancement issue.

[![](https://avatars.githubusercontent.com/u/247419485?s=64&v=4)ClineXDiego](https://github.com/ClineXDiego)

closed this as [completed](https://github.com/cline/cline/issues?q=is%3Aissue%20state%3Aclosed%20archived%3Afalse%20reason%3Acompleted) [on Mar 3on Mar 3, 2026](https://github.com/cline/cline/issues/4371#event-23239030122)

[Sign up for free](https://github.com/signup?return_to=https://github.com/cline/cline/issues/4371)**to join this conversation on GitHub.** Already have an account? [Sign in to comment](https://github.com/login?return_to=https://github.com/cline/cline/issues/4371)

## Metadata

## Metadata

### Assignees

No one assigned

### Labels

[Bot RespondedIssue has received an automated response](https://github.com/cline/cline/issues?q=state%3Aopen%20label%3A%22Bot%20Responded%22) Issue has received an automated response [Help WantedCommunity contributions welcome](https://github.com/cline/cline/issues?q=state%3Aopen%20label%3A%22Help%20Wanted%22) Community contributions welcome

### Type

No type

### Projects

No projects

### Milestone

No milestone

### Relationships

None yet

### Development

Code with agent mode

Select code repository

No branches or pull requests

### Participants

[![@realchrisolin](https://avatars.githubusercontent.com/u/1288116?s=64&u=9cd46204079272f65d10f774fa457bf7de0a6cb0&v=4)](https://github.com/realchrisolin)[![@saoudrizwan](https://avatars.githubusercontent.com/u/7799382?s=64&u=c78c6806a4c73fac6b2071bbafcccd8ae54ed055&v=4)](https://github.com/saoudrizwan)[![@arafatkatze](https://avatars.githubusercontent.com/u/11155207?s=64&u=cd4d7ee51cdd943f2bc1445788062f25a8dd3dcb&v=4)](https://github.com/arafatkatze)[![@vlebert](https://avatars.githubusercontent.com/u/49779177?s=64&v=4)](https://github.com/vlebert)[![@celestial-vault](https://avatars.githubusercontent.com/u/58194240?s=64&u=9b25d0ee2efcc7ba71bfa2f95b5b7eb904d3b45c&v=4)](https://github.com/celestial-vault)

+2

## Issue actions

You can’t perform that action at this time.