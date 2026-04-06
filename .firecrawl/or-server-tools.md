##### Beta

Server tools are currently in beta. The API and behavior may change.

Server tools are specialized tools operated by OpenRouter that any model can call during a request. When a model decides to use a server tool, OpenRouter executes it server-side and returns the result to the model — no client-side implementation needed.

## Server Tools vs Plugins vs User-Defined Tools

|  | Server Tools | Plugins | User-Defined Tools |
| --- | --- | --- | --- |
| **Who decides to use it** | The model | Always runs | The model |
| **Who executes it** | OpenRouter | OpenRouter | Your application |
| **Call frequency** | 0 to N times per request | Once per request | 0 to N times per request |
| **Specified via** | `tools` array | `plugins` array | `tools` array |
| **Type prefix** | `openrouter:*` | N/A | `function` |

**Server tools** are tools the model can invoke zero or more times during a request. OpenRouter handles execution transparently.

**Plugins** inject or mutate a request or response to add functionality (e.g. response healing, PDF parsing). They always run once when enabled.

**User-defined tools** are standard function-calling tools where the model suggests a call and _your_ application executes it.

## Available Server Tools

| Tool | Type | Description |
| --- | --- | --- |
| [**Web Search**](https://openrouter.ai/docs/guides/features/server-tools/web-search) | `openrouter:web_search` | Search the web for current information |
| [**Datetime**](https://openrouter.ai/docs/guides/features/server-tools/datetime) | `openrouter:datetime` | Get the current date and time |

## How Server Tools Work

1. You include one or more server tools in the `tools` array of your API request.
2. The model decides whether and when to call each server tool based on the user’s prompt.
3. OpenRouter intercepts the tool call, executes it server-side, and returns the result to the model.
4. The model uses the result to formulate its response. It may call the tool again if needed.

Server tools work alongside your own user-defined tools — you can include both in the same request.

## Quick Start

Add server tools to the `tools` array using the `openrouter:` type prefix:

TypeScriptPythoncURL

```
const response = await fetch('https://openrouter.ai/api/v1/chat/completions', {
  method: 'POST',
  headers: {
    Authorization: 'Bearer <OPENROUTER_API_KEY>',
    'Content-Type': 'application/json',
  },
  body: JSON.stringify({
    model: 'openai/gpt-5.2',
    messages: [\
      {\
        role: 'user',\
        content: 'What are the latest developments in AI?'\
      }\
    ],
    tools: [\
      { type: 'openrouter:web_search' },\
      { type: 'openrouter:datetime' }\
    ]
  }),
});

const data = await response.json();
console.log(data.choices[0].message.content);
```

## Combining with User-Defined Tools

Server tools and user-defined tools can be used in the same request:

```
{
  "model": "openai/gpt-5.2",
  "messages": [...],
  "tools": [\
    { "type": "openrouter:web_search", "parameters": { "max_results": 3 } },\
    { "type": "openrouter:datetime" },\
    {\
      "type": "function",\
      "function": {\
        "name": "get_stock_price",\
        "description": "Get the current stock price for a ticker symbol",\
        "parameters": {\
          "type": "object",\
          "properties": {\
            "ticker": { "type": "string" }\
          },\
          "required": ["ticker"]\
        }\
      }\
    }\
  ]
}
```

The model can call any combination of server tools and user-defined tools. OpenRouter executes the server tools automatically, while your application handles the user-defined tool calls as usual.

## Usage Tracking

Server tool usage is tracked in the response `usage` object:

```
{
  "usage": {
    "input_tokens": 105,
    "output_tokens": 250,
    "server_tool_use": {
      "web_search_requests": 2
    }
  }
}
```

## Next Steps

- [Web Search](https://openrouter.ai/docs/guides/features/server-tools/web-search) — Search the web for real-time information
- [Datetime](https://openrouter.ai/docs/guides/features/server-tools/datetime) — Get the current date and time
- [Tool Calling](https://openrouter.ai/docs/guides/features/tool-calling) — Learn about user-defined tool calling

Ask AI

Assistant

Responses are generated using AI and may contain mistakes.

Hi, I'm an AI assistant with access to documentation and other content.

Tip: You can toggle this pane with

`⌘`

+

`/`