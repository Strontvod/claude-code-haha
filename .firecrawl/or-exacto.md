Exacto is a virtual model variant that explicitly applies quality-first provider sorting. When you add `:exacto` to a model slug, OpenRouter prefers providers with stronger tool-calling quality signals for that model instead of using the default price-weighted ordering.

## Using the Exacto Variant

Add `:exacto` to the end of any supported model slug. This is a shortcut for setting the provider sort to Exacto on that model.

TypeScript SDKTypeScript (OpenAI SDK)cURL

```
import { OpenRouter } from '@openrouter/sdk';

const openRouter = new OpenRouter({
  apiKey: process.env.OPENROUTER_API_KEY,
});

const completion = await openRouter.chat.send({
  model: "moonshotai/kimi-k2-0905:exacto",
  messages: [\
    {\
      role: "user",\
      content: "Draft a concise changelog entry for the Exacto launch.",\
    },\
  ],
  stream: false,
});

console.log(completion.choices[0].message.content);
```

You can still supply fallback models with the `models` array. Any model that
carries the `:exacto` suffix will request Exacto sorting when it is selected.

## What Is the Exacto Variant?

Exacto is a routing shortcut for quality-first provider ordering. Unlike standard routing, which primarily favors lower-cost providers, Exacto prefers providers with stronger signals for tool-calling reliability and deprioritizes weaker performers.

## Why Use Exacto?

### Why We Built It

Providers serving the same model can vary meaningfully in tool-use behavior. Exacto gives you an explicit, request-level way to prefer higher-quality providers when you care more about tool-calling reliability than the default price-weighted route.

### Recommended Use Cases

Exacto is useful for quality-sensitive, agentic workflows where tool-calling accuracy and reliability matter more than raw cost efficiency.

## How Exacto Works

Exacto uses the same provider-ranking signals as [Auto Exacto](https://openrouter.ai/docs/guides/routing/auto-exacto), but applies them explicitly because you chose the `:exacto` suffix.

We use three classes of signals:

- Tool-calling success and reliability from real traffic
- Provider performance metrics such as throughput and latency
- Benchmark and evaluation data as it becomes available

Providers with strong track records are moved toward the front of the list. Providers with limited data are kept behind well-established performers, and providers with poor quality signals are deprioritized further.

## Exacto vs. Auto Exacto

- **Auto Exacto** runs automatically on tool-calling requests and requires no model suffix.
- **`:exacto`** is the explicit shortcut when you want to request the Exacto sorting mode directly on a specific model slug.

If you explicitly sort by price, throughput, or latency, that explicit sort still takes precedence.

## Supported Models

Exacto is a virtual variant and is not backed by a separate endpoint pool. It can be used anywhere provider sorting is meaningful, especially on models with multiple compatible providers.

In practice, Exacto is most useful on models that:

- Support tool calling
- Have multiple providers available on OpenRouter
- Show meaningful provider variance in tool-use reliability

If you have feedback on the Exacto variant, please fill out this form:
[https://openrouter.notion.site/2932fd57c4dc8097ba74ffb6d27f39d1?pvs=105](https://openrouter.notion.site/2932fd57c4dc8097ba74ffb6d27f39d1?pvs=105)

Ask AI

Assistant

Responses are generated using AI and may contain mistakes.

Hi, I'm an AI assistant with access to documentation and other content.

Tip: You can toggle this pane with

`⌘`

+

`/`