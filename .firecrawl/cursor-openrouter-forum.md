[Skip to main content](https://forum.cursor.com/t/cursor-is-practically-unusable-with-any-new-model-through-openrouter/143979#main-container)

- [Home](https://forum.cursor.com/)
- [Topics](https://forum.cursor.com/latest "All topics")
- [Users](https://forum.cursor.com/u "List of all users")
- [Badges](https://forum.cursor.com/badges "All the badges available to earn")
- [Groups](https://forum.cursor.com/g "List of available user groups")
- [About](https://forum.cursor.com/about "More details about this site")
- More


Categories


- [Announcements](https://forum.cursor.com/c/announcements/11 "Official updates from the Cursor team")
- [Events / Meetups](https://forum.cursor.com/c/events/15 "Official Cursor meetups and events—dates, locations, and how to join!")
- [Discussions](https://forum.cursor.com/c/general/4 "Talk shop with other Cursor users. Workflows, tips, model comparisons, and how you’re getting things done!")
- [Support](https://forum.cursor.com/c/support/21 "Get help from Cursor staff and the community. Post bug reports or ask questions about setup, configuration, and troubleshooting.")
- [Ideas](https://forum.cursor.com/c/ideas/22 "Wish Cursor did something differently? This is the place. Feature requests, feedback on existing functionality, and ideas for making Cursor better.")
- [All categories](https://forum.cursor.com/categories)

Tags


- [chat](https://forum.cursor.com/tag/chat/272 "")
- [cli](https://forum.cursor.com/tag/cli/313 "")
- [performance](https://forum.cursor.com/tag/performance/300 "")
- [crashes](https://forum.cursor.com/tag/crashes/301 "")
- [terminal](https://forum.cursor.com/tag/terminal/273 "")
- [All tags](https://forum.cursor.com/tags)

​

​


# [Cursor is practically unusable with any new model through OpenRouter](https://forum.cursor.com/t/cursor-is-practically-unusable-with-any-new-model-through-openrouter/143979)

[Support](https://forum.cursor.com/c/support/21) [Help](https://forum.cursor.com/c/support/help/8)

You have selected **0** posts.

[select all](https://forum.cursor.com/t/cursor-is-practically-unusable-with-any-new-model-through-openrouter/143979)

[cancel selecting](https://forum.cursor.com/t/cursor-is-practically-unusable-with-any-new-model-through-openrouter/143979)

[Nov 2025](https://forum.cursor.com/t/cursor-is-practically-unusable-with-any-new-model-through-openrouter/143979/1 "Jump to the first post")

2 / 4


Nov 2025


[Dec 2025](https://forum.cursor.com/t/cursor-is-practically-unusable-with-any-new-model-through-openrouter/143979/4)

## post by Ralek on Nov 24, 2025

[![](https://avatars.discourse-cdn.com/v4/letter/r/bc79bd/48.png)](https://forum.cursor.com/u/ralek)

[Ralek](https://forum.cursor.com/u/ralek)

[Nov 2025](https://forum.cursor.com/t/cursor-is-practically-unusable-with-any-new-model-through-openrouter/143979 "Post date")

### [Heading link](https://forum.cursor.com/t/cursor-is-practically-unusable-with-any-new-model-through-openrouter/143979\#p-297807-where-does-the-bug-appear-featureproduct-1) Where does the bug appear (feature/product)?

Cursor IDE

### [Heading link](https://forum.cursor.com/t/cursor-is-practically-unusable-with-any-new-model-through-openrouter/143979\#p-297807-describe-the-bug-2) Describe the Bug

I use OpenRouter to access models. But when I try, I get errors like these:

GPT5.1:

```swift
Request failed with status code 400: {"error":{"message":"Input required: specify \"prompt\" or \"messages\"","code":400},"user_id":"user_2smDyoir6cVtTliFhxZDiolmcWC"}
```

Gemini 3:

Will list the current directory or do some other tool call, then get this error:

```swift
Request failed with status code 400: {"error":{"message":"Provider returned error","code":400,"metadata":{"raw":"Gemini models require OpenRouter reasoning details to be preserved in each request. Please refer to our docs: https://openrouter.ai/docs/use-cases/reasoning-tokens#preserving-reasoning-blocks. Upstream error: {\n  \"error\": {\n    \"code\": 400,\n    \"message\": \"Unable to submit request because function call `default_api:list_dir` in the 2. content block is missing a `thought_signature`. Learn more: https://docs.cloud.google.com/vertex-ai/generative-ai/docs/thought-signatures\",\n    \"status\": \"INVALID_ARGUMENT\"\n  }\n}\n","provider_name":"Google"}},"user_id":"user_2smDyoir6cVtTliFhxZDiolmcWC"}
```

Claude sonnet 4.5:

```css
Request failed with status code 500: {"error":{"message":"Internal Server Error","code":500}}
```

Claude sonnet 4:

```css
Request failed with status code 500: {"error":{"message":"Internal Server Error","code":500}}
```

Only last gen models work at all.

### [Heading link](https://forum.cursor.com/t/cursor-is-practically-unusable-with-any-new-model-through-openrouter/143979\#p-297807-steps-to-reproduce-3) Steps to Reproduce

Use any modern model through OpenRouter

### [Heading link](https://forum.cursor.com/t/cursor-is-practically-unusable-with-any-new-model-through-openrouter/143979\#p-297807-operating-system-4) Operating System

Linux

### [Heading link](https://forum.cursor.com/t/cursor-is-practically-unusable-with-any-new-model-through-openrouter/143979\#p-297807-current-cursor-version-menu-about-cursor-copy-5) Current Cursor Version (Menu → About Cursor → Copy)

Version: 2.1.26

VSCode Version: 1.105.1

Commit: f628a4761be40b8869ca61a6189cafd14756dff0

Date: 2025-11-24T05:39:06.655Z

Electron: 37.7.0

Chromium: 138.0.7204.251

Node.js: 22.20.0

V8: 13.8.258.32-electron.0

OS: Linux x64 6.17.0-6-generic

### [Heading link](https://forum.cursor.com/t/cursor-is-practically-unusable-with-any-new-model-through-openrouter/143979\#p-297807-for-ai-issues-which-model-did-you-use-6) For AI issues: which model did you use?

Claude sonnet 4, Claude saonet 4.5, Gemini 3, GPT 5.1

### [Heading link](https://forum.cursor.com/t/cursor-is-practically-unusable-with-any-new-model-through-openrouter/143979\#p-297807-for-ai-issues-add-request-id-with-privacy-disabled-7) For AI issues: add Request ID with privacy disabled

Request ID: def4ae9a-9a68-430c-8a8d-667afe8bd7ef

{“error”:“ERROR\_OPENAI”,“details”:{“title”:“Unable to reach the model provider”,“detail”:“We encountered an issue when using your API key: Provider was unable to process your request\\n\\nAPI Error:\\n\\n`\nRequest failed with status code 500: {\"error\":{\"message\":\"Internal Server Error\",\"code\":500}}\n`”,“additionalInfo”:{},“buttons”:,“planChoices”:},“isExpected”:true}

ConnectError: \[invalid\_argument\] Error

at kZc.$endAiConnectTransportReportError (vscode-file://vscode-app/usr/share/cursor/resources/app/out/vs/workbench/workbench.desktop.main.js:6330:408452)

at HPo.\_doInvokeHandler (vscode-file://vscode-app/usr/share/cursor/resources/app/out/vs/workbench/workbench.desktop.main.js:7180:11314)

at HPo.\_invokeHandler (vscode-file://vscode-app/usr/share/cursor/resources/app/out/vs/workbench/workbench.desktop.main.js:7180:11056)

at HPo.\_receiveRequest (vscode-file://vscode-app/usr/share/cursor/resources/app/out/vs/workbench/workbench.desktop.main.js:7180:9818)

at HPo.\_receiveOneMessage (vscode-file://vscode-app/usr/share/cursor/resources/app/out/vs/workbench/workbench.desktop.main.js:7180:8635)

at yPt.value (vscode-file://vscode-app/usr/share/cursor/resources/app/out/vs/workbench/workbench.desktop.main.js:7180:6727)

at \_e.\_deliver (vscode-file://vscode-app/usr/share/cursor/resources/app/out/vs/workbench/workbench.desktop.main.js:49:2962)

at \_e.fire (vscode-file://vscode-app/usr/share/cursor/resources/app/out/vs/workbench/workbench.desktop.main.js:49:3283)

at Xmt.fire (vscode-file://vscode-app/usr/share/cursor/resources/app/out/vs/workbench/workbench.desktop.main.js:6315:12156)

at MessagePort. (vscode-file://vscode-app/usr/share/cursor/resources/app/out/vs/workbench/workbench.desktop.main.js:8972:18439)

Request ID: 82341f68-8e8d-4df5-b3f4-5fd7419ef5ce

{“error”:“ERROR\_OPENAI”,“details”:{“title”:“Unable to reach the model provider”,“detail”:“We encountered an issue when using your API key: Provider was unable to process your request\\n\\nAPI Error:\\n\\n`\nRequest failed with status code 500: {\"error\":{\"message\":\"Internal Server Error\",\"code\":500}}\n`”,“additionalInfo”:{},“buttons”:,“planChoices”:},“isExpected”:true}

ConnectError: \[invalid\_argument\] Error

at kZc.$endAiConnectTransportReportError (vscode-file://vscode-app/usr/share/cursor/resources/app/out/vs/workbench/workbench.desktop.main.js:6330:408452)

at HPo.\_doInvokeHandler (vscode-file://vscode-app/usr/share/cursor/resources/app/out/vs/workbench/workbench.desktop.main.js:7180:11314)

at HPo.\_invokeHandler (vscode-file://vscode-app/usr/share/cursor/resources/app/out/vs/workbench/workbench.desktop.main.js:7180:11056)

at HPo.\_receiveRequest (vscode-file://vscode-app/usr/share/cursor/resources/app/out/vs/workbench/workbench.desktop.main.js:7180:9818)

at HPo.\_receiveOneMessage (vscode-file://vscode-app/usr/share/cursor/resources/app/out/vs/workbench/workbench.desktop.main.js:7180:8635)

at yPt.value (vscode-file://vscode-app/usr/share/cursor/resources/app/out/vs/workbench/workbench.desktop.main.js:7180:6727)

at \_e.\_deliver (vscode-file://vscode-app/usr/share/cursor/resources/app/out/vs/workbench/workbench.desktop.main.js:49:2962)

at \_e.fire (vscode-file://vscode-app/usr/share/cursor/resources/app/out/vs/workbench/workbench.desktop.main.js:49:3283)

at Xmt.fire (vscode-file://vscode-app/usr/share/cursor/resources/app/out/vs/workbench/workbench.desktop.main.js:6315:12156)

at MessagePort. (vscode-file://vscode-app/usr/share/cursor/resources/app/out/vs/workbench/workbench.desktop.main.js:8972:18439)

Request ID: 4471af94-d400-4ffe-b5d9-fb7a6e2e1256

{“error”:“ERROR\_OPENAI”,“details”:{“title”:“Unable to reach the model provider”,“detail”:“We encountered an issue when using your API key: Provider was unable to process your request\\n\\nAPI Error:\\n\\n`\nRequest failed with status code 400: {\"error\":{\"message\":\"Input required: specify \\\"prompt\\\" or \\\"messages\\\"\",\"code\":400},\"user_id\":\"user_2smDyoir6cVtTliFhxZDiolmcWC\"}\n`”,“additionalInfo”:{},“buttons”:,“planChoices”:},“isExpected”:true}

ConnectError: \[invalid\_argument\] Error

at kZc.$endAiConnectTransportReportError (vscode-file://vscode-app/usr/share/cursor/resources/app/out/vs/workbench/workbench.desktop.main.js:6330:408452)

at HPo.\_doInvokeHandler (vscode-file://vscode-app/usr/share/cursor/resources/app/out/vs/workbench/workbench.desktop.main.js:7180:11314)

at HPo.\_invokeHandler (vscode-file://vscode-app/usr/share/cursor/resources/app/out/vs/workbench/workbench.desktop.main.js:7180:11056)

at HPo.\_receiveRequest (vscode-file://vscode-app/usr/share/cursor/resources/app/out/vs/workbench/workbench.desktop.main.js:7180:9818)

at HPo.\_receiveOneMessage (vscode-file://vscode-app/usr/share/cursor/resources/app/out/vs/workbench/workbench.desktop.main.js:7180:8635)

at yPt.value (vscode-file://vscode-app/usr/share/cursor/resources/app/out/vs/workbench/workbench.desktop.main.js:7180:6727)

at \_e.\_deliver (vscode-file://vscode-app/usr/share/cursor/resources/app/out/vs/workbench/workbench.desktop.main.js:49:2962)

at \_e.fire (vscode-file://vscode-app/usr/share/cursor/resources/app/out/vs/workbench/workbench.desktop.main.js:49:3283)

at Xmt.fire (vscode-file://vscode-app/usr/share/cursor/resources/app/out/vs/workbench/workbench.desktop.main.js:6315:12156)

at MessagePort. (vscode-file://vscode-app/usr/share/cursor/resources/app/out/vs/workbench/workbench.desktop.main.js:8972:18439)

Request ID: 2179aeb2-f4fa-4f7a-a00d-2c1cffb0cbf1

{“error”:“ERROR\_OPENAI”,“details”:{“title”:“Unable to reach the model provider”,“detail”:“We encountered an issue when using your API key: Provider was unable to process your request\\n\\nAPI Error:\\n\\n``\nRequest failed with status code 400: {\"error\":{\"message\":\"Provider returned error\",\"code\":400,\"metadata\":{\"raw\":\"Gemini models require OpenRouter reasoning details to be preserved in each request. Please refer to our docs: https://openrouter.ai/docs/use-cases/reasoning-tokens#preserving-reasoning-blocks. Upstream error: {\\n  \\\"error\\\": {\\n    \\\"code\\\": 400,\\n    \\\"message\\\": \\\"Unable to submit request because function call `default_api:list_dir` in the 2. content block is missing a `thought_signature`. Learn more: https://docs.cloud.google.com/vertex-ai/generative-ai/docs/thought-signatures\\\",\\n    \\\"status\\\": \\\"INVALID_ARGUMENT\\\"\\n  }\\n}\\n\",\"provider_name\":\"Google\"}},\"user_id\":\"user_2smDyoir6cVtTliFhxZDiolmcWC\"}\n``”,“additionalInfo”:{},“buttons”:,“planChoices”:},“isExpected”:true}

### [Heading link](https://forum.cursor.com/t/cursor-is-practically-unusable-with-any-new-model-through-openrouter/143979\#p-297807-does-this-stop-you-from-using-cursor-8) Does this stop you from using Cursor

Yes - Cursor is unusable

- [Using Gemini 3 Pro Preview with Openrouter Fails](https://forum.cursor.com/t/using-gemini-3-pro-preview-with-openrouter-fails/145521/2)
- [Qwen Code Companion extension](https://forum.cursor.com/t/qwen-code-companion-extension/150563/3)

1.4k
views
1
link


[![](https://avatars.discourse-cdn.com/v4/letter/r/bc79bd/48.png)](https://forum.cursor.com/u/Ralek "Ralek")

[![](https://avatars.discourse-cdn.com/v4/letter/k/49beb7/48.png)](https://forum.cursor.com/u/Koleboxx "Koleboxx")

[![](https://sea3.discourse-cdn.com/cursor1/user_avatar/forum.cursor.com/deanrie/48/1263_2.png)](https://forum.cursor.com/u/deanrie "deanrie")

## post by deanrie on Nov 25, 2025

[![](https://sea3.discourse-cdn.com/cursor1/user_avatar/forum.cursor.com/deanrie/48/1263_2.png)](https://forum.cursor.com/u/deanrie)

[Dean Rie](https://forum.cursor.com/u/deanrie)

[Nov 2025](https://forum.cursor.com/t/cursor-is-practically-unusable-with-any-new-model-through-openrouter/143979/2 "Post date")

Hey, thanks for the report. OpenRouter is not officially supported by Cursor, which is why you’re running into compatibility issues with newer models. The errors you’re seeing (missing thought\_signature, request format problems) happen because Cursor’s API implementation is built for officially supported providers.

Officially supported options:

1. Use a Cursor Pro subscription (includes Claude, GPT-5, and other models)
2. Add your own API keys for official providers (OpenAI, Anthropic, Google) in Settings → Models

Some older OpenRouter models might still work by chance, but there’s no guarantee they’ll stay compatible, especially as model APIs change over time (reasoning tokens, new function calling formats, etc).

If you need specific models that aren’t available through the official providers in Cursor, it’s better to use direct API keys from those providers instead of routing through OpenRouter.

## post by Koleboxx on Nov 26, 2025

[![](https://avatars.discourse-cdn.com/v4/letter/k/49beb7/48.png)](https://forum.cursor.com/u/koleboxx)

[Koleboxx](https://forum.cursor.com/u/koleboxx)

[Nov 2025](https://forum.cursor.com/t/cursor-is-practically-unusable-with-any-new-model-through-openrouter/143979/3 "Post date")

Since there is Bedrock and Azure integration, when will we see Vertex AI? OpenRouter was way to go, now I have to run custom local proxy exposing openAI endpoint to curosor and calling Google SDKs, which is not ideal as I run into occasional issues and need to change the implementation.

22 days later


## Closed on Dec 18, 2025

[![](https://sea3.discourse-cdn.com/cursor1/user_avatar/forum.cursor.com/system/24/99069_2.png)](https://forum.cursor.com/u/system)

Closed on Dec 18, 2025

This topic was automatically closed 22 days after the last reply. New replies are no longer allowed.

Reply

Invalid date

Invalid date