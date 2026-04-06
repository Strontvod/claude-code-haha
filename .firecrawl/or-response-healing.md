The Response Healing plugin automatically validates and repairs malformed JSON responses from AI models. When models return imperfect formatting – missing brackets, trailing commas, markdown wrappers, or mixed text – this plugin attempts to repair the response so you receive valid, parseable JSON.

## Overview

Response Healing provides:

- **Automatic JSON repair**: Fixes missing brackets, commas, quotes, and other syntax errors
- **Markdown extraction**: Extracts JSON from markdown code blocks

## How It Works

The plugin activates for non-streaming requests when you use `response_format` with either `type: "json_schema"` or `type: "json_object"`, and include the response-healing plugin in your `plugins` array. See the [Complete Example](https://openrouter.ai/docs/guides/features/plugins/response-healing#complete-example) below for a full implementation.

## What Gets Fixed

The Response Healing plugin handles common issues in LLM responses:

### JSON Syntax Errors

**Input:** Missing closing bracket

```
{"name": "Alice", "age": 30
```

**Output:** Fixed

```
{"name": "Alice", "age": 30}
```

### Markdown Code Blocks

**Input:** Wrapped in markdown

````
```json
{"name": "Bob"}
```
````

**Output:** Extracted

```
{"name": "Bob"}
```

### Mixed Text and JSON

**Input:** Text before JSON

```
Here's the data you requested:
{"name": "Charlie", "age": 25}
```

**Output:** Extracted

```
{"name": "Charlie", "age": 25}
```

### Trailing Commas

**Input:** Invalid trailing comma

```
{"name": "David", "age": 35,}
```

**Output:** Fixed

```
{"name": "David", "age": 35}
```

### Unquoted Keys

**Input:** JavaScript-style

```
{name: "Eve", age: 40}
```

**Output:** Fixed

```
{"name": "Eve", "age": 40}
```

## Complete Example

TypeScriptPython

```
const response = await fetch('https://openrouter.ai/api/v1/chat/completions', {
  method: 'POST',
  headers: {
    Authorization: 'Bearer <OPENROUTER_API_KEY>',
    'Content-Type': 'application/json',
  },
  body: JSON.stringify({
    model: 'google/gemini-2.5-flash',
    messages: [\
      {\
        role: 'user',\
        content: 'Generate a product listing with name, price, and description'\
      }\
    ],
    response_format: {
      type: 'json_schema',
      json_schema: {
        name: 'Product',
        schema: {
          type: 'object',
          properties: {
            name: {
              type: 'string',
              description: 'Product name'
            },
            price: {
              type: 'number',
              description: 'Price in USD'
            },
            description: {
              type: 'string',
              description: 'Product description'
            }
          },
          required: ['name', 'price']
        }
      }
    },
    plugins: [\
      { id: 'response-healing' }\
    ]
  }),
});

const data = await response.json();
const product = JSON.parse(data.choices[0].message.content);
// The plugin attempts to repair malformed JSON syntax
console.log(product.name, product.price);
```

## Limitations

##### Non-Streaming Requests Only

Response Healing only applies to non-streaming requests.

##### Will not repair all JSON

Some malformed JSON responses may still be unrepairable. In particular, if the response is truncated by `max_tokens`, the plugin will not be able to repair it.

Ask AI

Assistant

Responses are generated using AI and may contain mistakes.

Hi, I'm an AI assistant with access to documentation and other content.

Tip: You can toggle this pane with

`⌘`

+

`/`