##### Beta API

This API is in **beta stage** and may have breaking changes. Use with caution in production environments.

##### Stateless Only

This API is **stateless** \- each request is independent and no conversation state is persisted between requests. You must include the full conversation history in each request.

OpenRouter’s Responses API Beta provides OpenAI-compatible access to multiple AI models through a unified interface, designed to be a drop-in replacement for OpenAI’s Responses API. This stateless API offers enhanced capabilities including reasoning, tool calling, and web search integration, with each request being independent and no server-side state persisted.

## Base URL

```
https://openrouter.ai/api/v1/responses
```

## Authentication

All requests require authentication using your OpenRouter API key:

TypeScriptPythoncURL

```
const response = await fetch('https://openrouter.ai/api/v1/responses', {
  method: 'POST',
  headers: {
    'Authorization': 'Bearer YOUR_OPENROUTER_API_KEY',
    'Content-Type': 'application/json',
  },
  body: JSON.stringify({
    model: 'openai/o4-mini',
    input: 'Hello, world!',
  }),
});
```

## Core Features

### [Basic Usage](https://openrouter.ai/docs/api/reference/responses/basic-usage)

Learn the fundamentals of making requests with simple text input and handling responses.

### [Reasoning](https://openrouter.ai/docs/api/reference/responses/reasoning)

Access advanced reasoning capabilities with configurable effort levels and encrypted reasoning chains.

### [Tool Calling](https://openrouter.ai/docs/api/reference/responses/tool-calling)

Integrate function calling with support for parallel execution and complex tool interactions.

### [Web Search](https://openrouter.ai/docs/api/reference/responses/web-search)

Enable web search capabilities with real-time information retrieval and citation annotations.

## Error Handling

The API returns structured error responses:

```
{
  "error": {
    "code": "invalid_prompt",
    "message": "Missing required parameter: 'model'."
  },
  "metadata": null
}
```

For comprehensive error handling guidance, see [Error Handling](https://openrouter.ai/docs/api/reference/responses/error-handling).

## Rate Limits

Standard OpenRouter rate limits apply. See [API Limits](https://openrouter.ai/docs/api-reference/limits) for details.

Ask AI

Assistant

Responses are generated using AI and may contain mistakes.

Hi, I'm an AI assistant with access to documentation and other content.

Tip: You can toggle this pane with

`⌘`

+

`/`