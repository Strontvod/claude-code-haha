The `models` parameter lets you automatically try other models if the primary model’s providers are down, rate-limited, or refuse to reply due to content moderation.

## How It Works

Provide an array of model IDs in priority order. If the first model returns an error, OpenRouter will automatically try the next model in the list.

TypeScript SDKTypeScript (fetch)Python

```
import { OpenRouter } from '@openrouter/sdk';

const openRouter = new OpenRouter({
  apiKey: '<OPENROUTER_API_KEY>',
});

const completion = await openRouter.chat.send({
  models: ['anthropic/claude-3.5-sonnet', 'gryphe/mythomax-l2-13b'],
  messages: [\
    {\
      role: 'user',\
      content: 'What is the meaning of life?',\
    },\
  ],
});

console.log(completion.choices[0].message.content);
```

## Fallback Behavior

If the model you selected returns an error, OpenRouter will try to use the fallback model instead. If the fallback model is down or returns an error, OpenRouter will return that error.

By default, any error can trigger the use of a fallback model, including:

- Context length validation errors
- Moderation flags for filtered models
- Rate-limiting
- Downtime

## Pricing

Requests are priced using the model that was ultimately used, which will be returned in the `model` attribute of the response body.

## Using with OpenAI SDK

To use the `models` array with the OpenAI SDK, include it in the `extra_body` parameter. In the example below, gpt-4o will be tried first, and the `models` array will be tried in order as fallbacks.

PythonTypeScript

```
from openai import OpenAI

openai_client = OpenAI(
  base_url="https://openrouter.ai/api/v1",
  api_key=<OPENROUTER_API_KEY>,
)

completion = openai_client.chat.completions.create(
    model="openai/gpt-4o",
    extra_body={
        "models": ["anthropic/claude-3.5-sonnet", "gryphe/mythomax-l2-13b"],
    },
    messages=[\
        {\
            "role": "user",\
            "content": "What is the meaning of life?"\
        }\
    ]
)

print(completion.choices[0].message.content)
```

Ask AI

Assistant

Responses are generated using AI and may contain mistakes.

Hi, I'm an AI assistant with access to documentation and other content.

Tip: You can toggle this pane with

`⌘`

+

`/`