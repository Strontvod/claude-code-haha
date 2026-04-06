Zero Data Retention (ZDR) means that a provider will not store your data for any period of time.

OpenRouter has a [setting](https://openrouter.ai/settings/privacy) that, when enabled, only allows you to route to endpoints that have a Zero Data Retention policy.

Providers that do not retain your data are also unable to train on your data. However we do have some endpoints & providers who do not train on your data but _do_ retain it (e.g. to scan for abuse or for legal reasons). OpenRouter gives you controls over both of these policies.

## How OpenRouter Manages Data Policies

OpenRouter works with providers to understand each of their data policies and structures the policy data in a way that gives you control over which providers you want to route to.

Note that a provider’s general policy may differ from the specific policy for a given endpoint. OpenRouter keeps track of the specific policy for each endpoint, works with providers to keep these policies up to date, and in some cases creates special agreements with providers to ensure data retention or training policies that are more privacy-focused than their default policies.

If OpenRouter is not able to establish or ascertain a clear policy for a provider or endpoint, we take a conservative stance and assume that the endpoint both retains and trains on data and mark it as such.

A full list of providers and their data policies can be found [here](https://openrouter.ai/docs/guides/privacy/logging#data-retention--logging). Note that this list shows the default policy for each provider; if there is a particular endpoint that has a policy that differs from the provider default, it may not be available if “ZDR Only” is enabled.

## Per-Request ZDR Enforcement

In addition to the global ZDR setting in your [privacy settings](https://openrouter.ai/settings/privacy), you can enforce Zero Data Retention on a per-request basis using the `zdr` parameter in your API calls.

The request-level `zdr` parameter operates as an “OR” with your account-wide ZDR setting - if either is enabled, ZDR enforcement will be applied. This means the per-request parameter can only be used to ensure ZDR is enabled for a specific request, not to override or disable account-wide ZDR enforcement.

This is useful for customers who don’t want to globally enforce ZDR but need to ensure specific requests only route to ZDR endpoints.

### Usage

Include the `zdr` parameter in your provider preferences:

```
{
  "model": "gpt-4",
  "messages": [...],
  "provider": {
    "zdr": true
  }
}
```

When `zdr` is set to `true`, the request will only be routed to endpoints that have a Zero Data Retention policy. When `zdr` is `false` or not provided, ZDR enforcement will still apply if enabled in your account settings.

## Caching

Some endpoints/models provide implicit caching of prompts. This keeps repeated prompt data in an in-memory cache in the provider’s datacenter, so that the repeated part of the prompt does not need to be re-processed. This can lead to considerable cost savings.

OpenRouter has taken the stance that in-memory caching of prompts is _not_ considered “retaining” data, and we therefore allow endpoints/models with implicit caching to be hit when a ZDR routing policy is in effect.

## OpenRouter’s Retention Policy

OpenRouter itself has a ZDR policy; your prompts are not retained unless you specifically opt in to prompt logging.

## Zero Retention Endpoints

The following endpoints have a ZDR policy. Note that this list is also available progammatically via [https://openrouter.ai/api/v1/endpoints/zdr](https://openrouter.ai/api/v1/endpoints/zdr). It is automatically updated when there are changes to a provider’s data policy.:

| Model | Provider | Implicit Caching |
| --- | --- | --- |
| AlfredPros: CodeLLaMa 7B Instruct Solidity | Featherless | No |
| AllenAI: Olmo 3 32B Think | Parasail | No |
| AllenAI: Olmo 3.1 32B Instruct | DeepInfra | No |
| AllenAI: Olmo 3.1 32B Think | Parasail | No |
| Amazon: Nova 2 Lite | Amazon Bedrock | No |
| Amazon: Nova Lite 1.0 | Amazon Bedrock | No |
| Amazon: Nova Micro 1.0 | Amazon Bedrock | No |
| Amazon: Nova Premier 1.0 | Amazon Bedrock | No |
| Amazon: Nova Pro 1.0 | Amazon Bedrock | No |
| Anthropic: Claude 3 Haiku | Amazon Bedrock | No |
| Anthropic: Claude 3 Haiku | Google | No |
| Anthropic: Claude 3.5 Haiku | Amazon Bedrock | No |
| Anthropic: Claude 3.5 Haiku | Amazon Bedrock | No |
| Anthropic: Claude 3.5 Haiku | Google | No |
| Anthropic: Claude 3.7 Sonnet | Amazon Bedrock | No |
| Anthropic: Claude 3.7 Sonnet | Google | No |
| Anthropic: Claude 3.7 Sonnet | Google | No |
| Anthropic: Claude 3.7 Sonnet | Google | No |
| Anthropic: Claude 3.7 Sonnet | Google | No |
| Anthropic: Claude Haiku 4.5 | Amazon Bedrock | No |
| Anthropic: Claude Haiku 4.5 | Google | No |
| Anthropic: Claude Opus 4 | Google | No |
| Anthropic: Claude Opus 4 | Amazon Bedrock | No |
| Anthropic: Claude Opus 4 | Google | No |
| Anthropic: Claude Opus 4.1 | Google | No |
| Anthropic: Claude Opus 4.1 | Google | No |
| Anthropic: Claude Opus 4.1 | Google | No |
| Anthropic: Claude Opus 4.1 | Amazon Bedrock | No |
| Anthropic: Claude Opus 4.5 | Amazon Bedrock | No |
| Anthropic: Claude Opus 4.5 | Google | No |
| Anthropic: Claude Opus 4.6 | Amazon Bedrock | No |
| Anthropic: Claude Opus 4.6 | Google | No |
| Anthropic: Claude Opus 4.6 | Azure | No |
| Anthropic: Claude Sonnet 4 | Google | No |
| Anthropic: Claude Sonnet 4 | Amazon Bedrock | No |
| Anthropic: Claude Sonnet 4 | Google | No |
| Anthropic: Claude Sonnet 4 | Google | No |
| Anthropic: Claude Sonnet 4.5 | Google | No |
| Anthropic: Claude Sonnet 4.5 | Amazon Bedrock | No |
| Anthropic: Claude Sonnet 4.5 | Google | No |
| Anthropic: Claude Sonnet 4.6 | Google | No |
| Anthropic: Claude Sonnet 4.6 | Google | No |
| Anthropic: Claude Sonnet 4.6 | Amazon Bedrock | No |
| Anthropic: Claude Sonnet 4.6 | Azure | No |
| Arcee AI: Coder Large | Together | No |
| Arcee AI: Maestro Reasoning | Together | No |
| Arcee AI: Spotlight | Together | No |
| Arcee AI: Trinity Large Preview | Arcee AI | No |
| Arcee AI: Trinity Large Thinking | Parasail | No |
| Arcee AI: Trinity Large Thinking | Arcee AI | No |
| Arcee AI: Trinity Mini | Clarifai | No |
| Arcee AI: Trinity Mini | Arcee AI | No |
| Arcee AI: Virtuoso Large | Together | No |
| BAAI: bge-base-en-v1.5 | DeepInfra | No |
| BAAI: bge-large-en-v1.5 | DeepInfra | No |
| BAAI: bge-m3 | DeepInfra | No |
| Baidu: ERNIE 4.5 21B A3B | Novita | No |
| Baidu: ERNIE 4.5 21B A3B Thinking | Novita | No |
| Baidu: ERNIE 4.5 300B A47B | Novita | No |
| Baidu: ERNIE 4.5 300B A47B | SiliconFlow | No |
| Baidu: ERNIE 4.5 VL 28B A3B | Novita | No |
| Baidu: ERNIE 4.5 VL 424B A47B | Novita | No |
| ByteDance Seed: Seed 1.6 | Seed | No |
| ByteDance Seed: Seed 1.6 Flash | Seed | No |
| ByteDance Seed: Seed-2.0-Lite | Seed | No |
| ByteDance Seed: Seed-2.0-Mini | Seed | No |
| ByteDance Seed: Seedream 4.5 | Seed | No |
| ByteDance: UI-TARS 7B | Parasail | No |
| Deep Cogito: Cogito v2.1 671B | Together | No |
| DeepSeek: DeepSeek V3 | DeepInfra | No |
| DeepSeek: DeepSeek V3 | Novita | No |
| DeepSeek: DeepSeek V3 0324 | SambaNova | No |
| DeepSeek: DeepSeek V3 0324 | ModelRun | No |
| DeepSeek: DeepSeek V3 0324 | BaseTen | No |
| DeepSeek: DeepSeek V3 0324 | DeepInfra | No |
| DeepSeek: DeepSeek V3 0324 | AtlasCloud | No |
| DeepSeek: DeepSeek V3 0324 | SiliconFlow | No |
| DeepSeek: DeepSeek V3 0324 | Novita | No |
| DeepSeek: DeepSeek V3.1 | AtlasCloud | No |
| DeepSeek: DeepSeek V3.1 | Novita | No |
| DeepSeek: DeepSeek V3.1 | Fireworks | No |
| DeepSeek: DeepSeek V3.1 | SiliconFlow | No |
| DeepSeek: DeepSeek V3.1 | DeepInfra | No |
| DeepSeek: DeepSeek V3.1 | SambaNova | No |
| DeepSeek: DeepSeek V3.1 | SambaNova | No |
| DeepSeek: DeepSeek V3.1 | Google | No |
| DeepSeek: DeepSeek V3.1 | Together | No |
| DeepSeek: DeepSeek V3.1 Terminus | SambaNova | No |
| DeepSeek: DeepSeek V3.1 Terminus | Novita | No |
| DeepSeek: DeepSeek V3.1 Terminus | DeepInfra | No |
| DeepSeek: DeepSeek V3.1 Terminus | SiliconFlow | No |
| DeepSeek: DeepSeek V3.1 Terminus | AtlasCloud | No |
| DeepSeek: DeepSeek V3.2 | Novita | No |
| DeepSeek: DeepSeek V3.2 | SiliconFlow | No |
| DeepSeek: DeepSeek V3.2 | DeepInfra | No |
| DeepSeek: DeepSeek V3.2 | Parasail | No |
| DeepSeek: DeepSeek V3.2 | Google | No |
| DeepSeek: DeepSeek V3.2 | AtlasCloud | No |
| DeepSeek: DeepSeek V3.2 | AtlasCloud | No |
| DeepSeek: DeepSeek V3.2 | Io Net | No |
| DeepSeek: DeepSeek V3.2 | AkashML | No |
| DeepSeek: DeepSeek V3.2 Exp | Novita | No |
| DeepSeek: DeepSeek V3.2 Exp | SiliconFlow | No |
| DeepSeek: DeepSeek V3.2 Exp | AtlasCloud | No |
| DeepSeek: DeepSeek V3.2 Speciale | AtlasCloud | No |
| DeepSeek: R1 | Azure | No |
| DeepSeek: R1 | Novita | No |
| DeepSeek: R1 0528 | Together | No |
| DeepSeek: R1 0528 | SambaNova | No |
| DeepSeek: R1 0528 | Nebius | No |
| DeepSeek: R1 0528 | DeepInfra | No |
| DeepSeek: R1 0528 | Nebius | No |
| DeepSeek: R1 0528 | Novita | No |
| DeepSeek: R1 0528 | AtlasCloud | No |
| DeepSeek: R1 0528 | SiliconFlow | No |
| DeepSeek: R1 Distill Llama 70B | SambaNova | No |
| DeepSeek: R1 Distill Llama 70B | DeepInfra | No |
| DeepSeek: R1 Distill Llama 70B | Novita | No |
| DeepSeek: R1 Distill Qwen 32B | NextBit | No |
| EleutherAI: Llemma 7b | Featherless | No |
| EssentialAI: Rnj 1 Instruct | Together | No |
| Goliath 120B | Mancer 2 | No |
| Google: Gemini 2.0 Flash | Google | No |
| Google: Gemini 2.0 Flash Lite | Google | No |
| Google: Gemini 2.5 Flash | Google | No |
| Google: Gemini 2.5 Flash | Google | No |
| Google: Gemini 2.5 Flash Lite | Google | No |
| Google: Gemini 2.5 Flash Lite Preview 09-2025 | Google | No |
| Google: Gemini 2.5 Pro | Google | No |
| Google: Gemini 2.5 Pro | Google | No |
| Google: Gemini 2.5 Pro Preview 05-06 | Google | No |
| Google: Gemini 2.5 Pro Preview 06-05 | Google | No |
| Google: Gemini 3 Flash Preview | Google | Yes |
| Google: Gemini 3.1 Flash Lite Preview | Google | Yes |
| Google: Gemini 3.1 Pro Preview | Google | No |
| Google: Gemma 2 27B | NextBit | No |
| Google: Gemma 2 9B | Nebius | No |
| Google: Gemma 3 12B | DeepInfra | No |
| Google: Gemma 3 27B | DeepInfra | No |
| Google: Gemma 3 27B | Phala | No |
| Google: Gemma 3 27B | Parasail | No |
| Google: Gemma 3 27B | Novita | No |
| Google: Gemma 3 4B | DeepInfra | No |
| Google: Gemma 3n 4B | Together | No |
| Google: Gemma 4 26B A4B | Parasail | No |
| Google: Gemma 4 26B A4B | Novita | No |
| Google: Gemma 4 31B | Novita | No |
| Google: Gemma 4 31B | Parasail | No |
| Google: Gemma 4 31B | AkashML | No |
| Google: Nano Banana (Gemini 2.5 Flash Image) | Google | No |
| Google: Nano Banana 2 (Gemini 3.1 Flash Image Preview) | Google | No |
| Google: Nano Banana Pro (Gemini 3 Pro Image Preview) | Google | No |
| Inception: Mercury | Inception | No |
| Inception: Mercury 2 | Inception | No |
| Inception: Mercury Coder | Inception | No |
| Intfloat: E5-Base-v2 | DeepInfra | No |
| Intfloat: E5-Large-v2 | DeepInfra | No |
| Intfloat: Multilingual-E5-Large | DeepInfra | No |
| Kwaipilot: KAT-Coder-Pro V2 | StreamLake | No |
| Kwaipilot: KAT-Coder-Pro V2 | AtlasCloud | No |
| LiquidAI: LFM2-24B-A2B | Together | No |
| Llama Guard 3 8B | Nebius | No |
| Magnum v4 72B | Mancer 2 | No |
| Mancer: Weaver (alpha) | Mancer 2 | No |
| Meituan: LongCat Flash Chat | AtlasCloud | No |
| Meta: Llama 3 70B Instruct | Novita | No |
| Meta: Llama 3 8B Instruct | Novita | No |
| Meta: Llama 3 8B Instruct | Together | No |
| Meta: Llama 3 8B Instruct | DeepInfra | No |
| Meta: Llama 3.1 70B Instruct | DeepInfra | No |
| Meta: Llama 3.1 70B Instruct | DeepInfra | No |
| Meta: Llama 3.1 8B Instruct | SambaNova | No |
| Meta: Llama 3.1 8B Instruct | Novita | No |
| Meta: Llama 3.1 8B Instruct | Nebius | No |
| Meta: Llama 3.1 8B Instruct | DeepInfra | No |
| Meta: Llama 3.1 8B Instruct | Cerebras | No |
| Meta: Llama 3.1 8B Instruct | Nebius | No |
| Meta: Llama 3.1 8B Instruct | Groq | No |
| Meta: Llama 3.2 11B Vision Instruct | DeepInfra | No |
| Meta: Llama 3.2 3B Instruct | Venice | No |
| Meta: Llama 3.3 70B Instruct | Together | No |
| Meta: Llama 3.3 70B Instruct | Google | No |
| Meta: Llama 3.3 70B Instruct | Nebius | No |
| Meta: Llama 3.3 70B Instruct | SambaNova | No |
| Meta: Llama 3.3 70B Instruct | SambaNova | No |
| Meta: Llama 3.3 70B Instruct | Parasail | No |
| Meta: Llama 3.3 70B Instruct | Groq | No |
| Meta: Llama 3.3 70B Instruct | Nebius | No |
| Meta: Llama 3.3 70B Instruct | Venice | No |
| Meta: Llama 3.3 70B Instruct | Inceptron | No |
| Meta: Llama 3.3 70B Instruct | DeepInfra | No |
| Meta: Llama 3.3 70B Instruct | Google | No |
| Meta: Llama 3.3 70B Instruct | Novita | No |
| Meta: Llama 3.3 70B Instruct | AkashML | No |
| Meta: Llama 4 Maverick | DeepInfra | No |
| Meta: Llama 4 Maverick | SambaNova | No |
| Meta: Llama 4 Maverick | Novita | No |
| Meta: Llama 4 Maverick | Parasail | No |
| Meta: Llama 4 Maverick | Google | No |
| Meta: Llama 4 Maverick | Google | No |
| Meta: Llama 4 Scout | DeepInfra | No |
| Meta: Llama 4 Scout | Groq | No |
| Meta: Llama 4 Scout | Novita | No |
| Meta: Llama 4 Scout | Google | No |
| Meta: Llama Guard 4 12B | Together | No |
| Meta: Llama Guard 4 12B | DeepInfra | No |
| Microsoft: Phi 4 | NextBit | No |
| Microsoft: Phi 4 | DeepInfra | No |
| MiniMax: MiniMax M1 | Novita | No |
| MiniMax: MiniMax M2 | Minimax | No |
| MiniMax: MiniMax M2 | Google | No |
| MiniMax: MiniMax M2 | Novita | No |
| MiniMax: MiniMax M2 | AtlasCloud | No |
| MiniMax: MiniMax M2.1 | Venice | No |
| MiniMax: MiniMax M2.1 | Novita | No |
| MiniMax: MiniMax M2.1 | Nebius | No |
| MiniMax: MiniMax M2.1 | Fireworks | No |
| MiniMax: MiniMax M2.1 | Minimax | No |
| MiniMax: MiniMax M2.1 | Minimax | No |
| MiniMax: MiniMax M2.1 | AtlasCloud | No |
| MiniMax: MiniMax M2.1 | DeepInfra | No |
| MiniMax: MiniMax M2.5 | DeepInfra | No |
| MiniMax: MiniMax M2.5 | Venice | No |
| MiniMax: MiniMax M2.5 | Mara | No |
| MiniMax: MiniMax M2.5 | Parasail | No |
| MiniMax: MiniMax M2.5 | Minimax | No |
| MiniMax: MiniMax M2.5 | Minimax | No |
| MiniMax: MiniMax M2.5 | Novita | No |
| MiniMax: MiniMax M2.5 | Together | No |
| MiniMax: MiniMax M2.5 | SiliconFlow | No |
| MiniMax: MiniMax M2.5 | NextBit | No |
| MiniMax: MiniMax M2.5 | SambaNova | No |
| MiniMax: MiniMax M2.5 | AtlasCloud | No |
| MiniMax: MiniMax M2.5 | Io Net | No |
| MiniMax: MiniMax M2.5 | Ionstream | No |
| MiniMax: MiniMax M2.5 | AkashML | No |
| MiniMax: MiniMax M2.5 | Inceptron | No |
| MiniMax: MiniMax M2.5 | Nebius | No |
| MiniMax: MiniMax M2.7 | Minimax | No |
| MiniMax: MiniMax M2.7 | Minimax | No |
| MiniMax: MiniMax-M1-80k | Novita | No |
| Mistral: Ministral 3 14B 2512 | NextBit | No |
| Mistral: Ministral 3 3B 2512 | NextBit | No |
| Mistral: Ministral 3 8B 2512 | NextBit | No |
| Mistral: Mistral Nemo | DeepInfra | No |
| Mistral: Mistral Nemo | Novita | No |
| Mistral: Mistral Small 3 | DeepInfra | No |
| Mistral: Mistral Small 3.2 24B | Parasail | No |
| Mistral: Mistral Small 3.2 24B | DeepInfra | No |
| Mistral: Mistral Small 3.2 24B | Venice | No |
| Mistral: Mixtral 8x7B Instruct | DeepInfra | No |
| Mistral: Mixtral 8x7B Instruct | Together | No |
| MoonshotAI: Kimi K2 0711 | Novita | No |
| MoonshotAI: Kimi K2 0905 | Groq | Yes |
| MoonshotAI: Kimi K2 0905 | DeepInfra | No |
| MoonshotAI: Kimi K2 0905 | Novita | No |
| MoonshotAI: Kimi K2 0905 | Fireworks | No |
| MoonshotAI: Kimi K2 0905 | SiliconFlow | No |
| MoonshotAI: Kimi K2 0905 | AtlasCloud | No |
| MoonshotAI: Kimi K2 Thinking | DeepInfra | No |
| MoonshotAI: Kimi K2 Thinking | Nebius | No |
| MoonshotAI: Kimi K2 Thinking | Novita | No |
| MoonshotAI: Kimi K2 Thinking | Google | No |
| MoonshotAI: Kimi K2 Thinking | AtlasCloud | No |
| MoonshotAI: Kimi K2.5 | ModelRun | No |
| MoonshotAI: Kimi K2.5 | Together | No |
| MoonshotAI: Kimi K2.5 | Venice | No |
| MoonshotAI: Kimi K2.5 | Phala | No |
| MoonshotAI: Kimi K2.5 | Parasail | No |
| MoonshotAI: Kimi K2.5 | Novita | No |
| MoonshotAI: Kimi K2.5 | NextBit | No |
| MoonshotAI: Kimi K2.5 | Moonshot AI | No |
| MoonshotAI: Kimi K2.5 | AtlasCloud | No |
| MoonshotAI: Kimi K2.5 | BaseTen | No |
| MoonshotAI: Kimi K2.5 | DeepInfra | No |
| MoonshotAI: Kimi K2.5 | Inceptron | No |
| MoonshotAI: Kimi K2.5 | SiliconFlow | No |
| MoonshotAI: Kimi K2.5 | Fireworks | No |
| MoonshotAI: Kimi K2.5 | Io Net | No |
| Morph: Morph V3 Fast | Morph | No |
| Morph: Morph V3 Large | Morph | No |
| MythoMax 13B | DeepInfra | No |
| MythoMax 13B | Mancer 2 | No |
| MythoMax 13B | NextBit | No |
| Nex AGI: DeepSeek V3.1 Nex N1 | SiliconFlow | No |
| Nous: Hermes 3 405B Instruct | Venice | No |
| Nous: Hermes 3 405B Instruct | DeepInfra | No |
| Nous: Hermes 3 70B Instruct | DeepInfra | No |
| Nous: Hermes 4 405B | Nebius | No |
| Nous: Hermes 4 70B | Nebius | No |
| NousResearch: Hermes 2 Pro - Llama-3 8B | Novita | No |
| NVIDIA: Llama 3.1 Nemotron 70B Instruct | DeepInfra | No |
| NVIDIA: Llama 3.1 Nemotron Ultra 253B v1 | Nebius | No |
| NVIDIA: Llama 3.3 Nemotron Super 49B V1.5 | DeepInfra | No |
| NVIDIA: Llama Nemotron Embed VL 1B V2 | Nvidia | No |
| NVIDIA: Nemotron 3 Nano 30B A3B | DeepInfra | No |
| NVIDIA: Nemotron 3 Super | Nebius | No |
| NVIDIA: Nemotron 3 Super | DeepInfra | No |
| NVIDIA: Nemotron Nano 12B 2 VL | DeepInfra | No |
| NVIDIA: Nemotron Nano 9B V2 | DeepInfra | No |
| OpenAI: GPT-3.5 Turbo (older v0613) | Azure | No |
| OpenAI: GPT-3.5 Turbo 16k | Azure | No |
| OpenAI: GPT-4 | Azure | No |
| OpenAI: GPT-4.1 | Azure | Yes |
| OpenAI: GPT-4.1 Mini | Azure | Yes |
| OpenAI: GPT-4.1 Nano | Azure | Yes |
| OpenAI: GPT-4o | Azure | No |
| OpenAI: GPT-4o (2024-05-13) | Azure | No |
| OpenAI: GPT-4o (2024-08-06) | Azure | No |
| OpenAI: GPT-4o-mini | Azure | No |
| OpenAI: GPT-5 | Azure | Yes |
| OpenAI: GPT-5 Mini | Azure | No |
| OpenAI: GPT-5 Nano | Azure | No |
| OpenAI: GPT-5.1 | Azure | Yes |
| OpenAI: GPT-5.1 Chat | Azure | Yes |
| OpenAI: GPT-5.1-Codex | Azure | Yes |
| OpenAI: GPT-5.1-Codex-Max | Azure | Yes |
| OpenAI: GPT-5.1-Codex-Mini | Azure | Yes |
| OpenAI: GPT-5.2 | Azure | Yes |
| OpenAI: GPT-5.2 Chat | Azure | Yes |
| OpenAI: GPT-5.2-Codex | Azure | Yes |
| OpenAI: GPT-5.3 Chat | Azure | No |
| OpenAI: GPT-5.3-Codex | Azure | No |
| OpenAI: GPT-5.4 | Azure | No |
| OpenAI: GPT-5.4 Mini | Azure | No |
| OpenAI: GPT-5.4 Nano | Azure | No |
| OpenAI: GPT-5.4 Pro | Azure | No |
| OpenAI: gpt-oss-120b | Amazon Bedrock | No |
| OpenAI: gpt-oss-120b | Phala | No |
| OpenAI: gpt-oss-120b | DeepInfra | No |
| OpenAI: gpt-oss-120b | SambaNova | No |
| OpenAI: gpt-oss-120b | Together | No |
| OpenAI: gpt-oss-120b | Parasail | No |
| OpenAI: gpt-oss-120b | Clarifai | No |
| OpenAI: gpt-oss-120b | Novita | No |
| OpenAI: gpt-oss-120b | BaseTen | No |
| OpenAI: gpt-oss-120b | SiliconFlow | No |
| OpenAI: gpt-oss-120b | Groq | No |
| OpenAI: gpt-oss-120b | Google | No |
| OpenAI: gpt-oss-120b | Fireworks | No |
| OpenAI: gpt-oss-120b | DeepInfra | No |
| OpenAI: gpt-oss-120b | Io Net | No |
| OpenAI: gpt-oss-120b | AtlasCloud | No |
| OpenAI: gpt-oss-120b | Cerebras | No |
| OpenAI: gpt-oss-20b | Parasail | No |
| OpenAI: gpt-oss-20b | NextBit | No |
| OpenAI: gpt-oss-20b | Clarifai | No |
| OpenAI: gpt-oss-20b | Novita | No |
| OpenAI: gpt-oss-20b | Nebius | No |
| OpenAI: gpt-oss-20b | Together | No |
| OpenAI: gpt-oss-20b | Amazon Bedrock | No |
| OpenAI: gpt-oss-20b | Groq | No |
| OpenAI: gpt-oss-20b | DeepInfra | No |
| OpenAI: gpt-oss-20b | Fireworks | No |
| OpenAI: gpt-oss-20b | Google | No |
| OpenAI: gpt-oss-safeguard-20b | Groq | No |
| Perplexity: Embed V1 0.6B | Perplexity | No |
| Perplexity: Embed V1 4B | Perplexity | No |
| Perplexity: Sonar | Perplexity | No |
| Perplexity: Sonar Deep Research | Perplexity | No |
| Perplexity: Sonar Pro | Perplexity | No |
| Perplexity: Sonar Pro Search | Perplexity | No |
| Perplexity: Sonar Reasoning Pro | Perplexity | No |
| Prime Intellect: INTELLECT-3 | Nebius | No |
| Qwen: Qwen2.5 7B Instruct | Phala | No |
| Qwen: Qwen2.5 7B Instruct | Together | No |
| Qwen: Qwen2.5 7B Instruct | AtlasCloud | No |
| Qwen: Qwen2.5 Coder 7B Instruct | Nebius | No |
| Qwen: Qwen2.5 VL 32B Instruct | DeepInfra | No |
| Qwen: Qwen2.5 VL 72B Instruct | Parasail | No |
| Qwen: Qwen2.5 VL 72B Instruct | Novita | No |
| Qwen: Qwen3 14B | DeepInfra | No |
| Qwen: Qwen3 14B | NextBit | No |
| Qwen: Qwen3 235B A22B Instruct 2507 | Novita | No |
| Qwen: Qwen3 235B A22B Instruct 2507 | Together | No |
| Qwen: Qwen3 235B A22B Instruct 2507 | Google | No |
| Qwen: Qwen3 235B A22B Instruct 2507 | Cerebras | No |
| Qwen: Qwen3 235B A22B Instruct 2507 | AtlasCloud | No |
| Qwen: Qwen3 235B A22B Instruct 2507 | SiliconFlow | No |
| Qwen: Qwen3 235B A22B Instruct 2507 | DeepInfra | No |
| Qwen: Qwen3 235B A22B Instruct 2507 | Parasail | No |
| Qwen: Qwen3 235B A22B Instruct 2507 | Google | No |
| Qwen: Qwen3 235B A22B Thinking 2507 | Novita | No |
| Qwen: Qwen3 235B A22B Thinking 2507 | DeepInfra | No |
| Qwen: Qwen3 235B A22B Thinking 2507 | AtlasCloud | No |
| Qwen: Qwen3 30B A3B | NextBit | No |
| Qwen: Qwen3 30B A3B | DeepInfra | No |
| Qwen: Qwen3 30B A3B | Novita | No |
| Qwen: Qwen3 30B A3B Instruct 2507 | Nebius | No |
| Qwen: Qwen3 30B A3B Instruct 2507 | AtlasCloud | No |
| Qwen: Qwen3 30B A3B Instruct 2507 | SiliconFlow | No |
| Qwen: Qwen3 30B A3B Thinking 2507 | Nebius | No |
| Qwen: Qwen3 30B A3B Thinking 2507 | SiliconFlow | No |
| Qwen: Qwen3 30B A3B Thinking 2507 | AtlasCloud | No |
| Qwen: Qwen3 32B | Groq | No |
| Qwen: Qwen3 32B | Nebius | No |
| Qwen: Qwen3 32B | SambaNova | No |
| Qwen: Qwen3 32B | Novita | No |
| Qwen: Qwen3 32B | DeepInfra | No |
| Qwen: Qwen3 32B | SiliconFlow | No |
| Qwen: Qwen3 32B | AtlasCloud | No |
| Qwen: Qwen3 8B | AtlasCloud | No |
| Qwen: Qwen3 Coder 30B A3B Instruct | Novita | No |
| Qwen: Qwen3 Coder 30B A3B Instruct | Nebius | No |
| Qwen: Qwen3 Coder 30B A3B Instruct | Amazon Bedrock | No |
| Qwen: Qwen3 Coder 30B A3B Instruct | SiliconFlow | No |
| Qwen: Qwen3 Coder 480B A35B | Venice | No |
| Qwen: Qwen3 Coder 480B A35B | Venice | No |
| Qwen: Qwen3 Coder 480B A35B | Novita | No |
| Qwen: Qwen3 Coder 480B A35B | SiliconFlow | No |
| Qwen: Qwen3 Coder 480B A35B | DeepInfra | No |
| Qwen: Qwen3 Coder 480B A35B | DeepInfra | No |
| Qwen: Qwen3 Coder 480B A35B | Google | No |
| Qwen: Qwen3 Coder 480B A35B | Together | No |
| Qwen: Qwen3 Coder 480B A35B | AtlasCloud | No |
| Qwen: Qwen3 Coder Next | Novita | No |
| Qwen: Qwen3 Coder Next | Ionstream | No |
| Qwen: Qwen3 Coder Next | Parasail | No |
| Qwen: Qwen3 Coder Next | AtlasCloud | No |
| Qwen: Qwen3 Coder Next | Together | No |
| Qwen: Qwen3 Embedding 4B | DeepInfra | No |
| Qwen: Qwen3 Embedding 8B | SiliconFlow | No |
| Qwen: Qwen3 Embedding 8B | Nebius | No |
| Qwen: Qwen3 Embedding 8B | DeepInfra | No |
| Qwen: Qwen3 Next 80B A3B Instruct | Parasail | No |
| Qwen: Qwen3 Next 80B A3B Instruct | Novita | No |
| Qwen: Qwen3 Next 80B A3B Instruct | DeepInfra | No |
| Qwen: Qwen3 Next 80B A3B Instruct | Google | No |
| Qwen: Qwen3 Next 80B A3B Instruct | Venice | No |
| Qwen: Qwen3 Next 80B A3B Instruct | AtlasCloud | No |
| Qwen: Qwen3 Next 80B A3B Thinking | Novita | No |
| Qwen: Qwen3 Next 80B A3B Thinking | Nebius | No |
| Qwen: Qwen3 Next 80B A3B Thinking | Google | No |
| Qwen: Qwen3 Next 80B A3B Thinking | AtlasCloud | No |
| Qwen: Qwen3 VL 235B A22B Instruct | AtlasCloud | No |
| Qwen: Qwen3 VL 235B A22B Instruct | DeepInfra | No |
| Qwen: Qwen3 VL 235B A22B Instruct | Parasail | No |
| Qwen: Qwen3 VL 235B A22B Instruct | Novita | No |
| Qwen: Qwen3 VL 235B A22B Instruct | SiliconFlow | No |
| Qwen: Qwen3 VL 235B A22B Instruct | Venice | No |
| Qwen: Qwen3 VL 235B A22B Thinking | SiliconFlow | No |
| Qwen: Qwen3 VL 235B A22B Thinking | Novita | No |
| Qwen: Qwen3 VL 30B A3B Instruct | Venice | No |
| Qwen: Qwen3 VL 30B A3B Instruct | DeepInfra | No |
| Qwen: Qwen3 VL 30B A3B Instruct | Novita | No |
| Qwen: Qwen3 VL 30B A3B Instruct | Phala | No |
| Qwen: Qwen3 VL 30B A3B Instruct | SiliconFlow | No |
| Qwen: Qwen3 VL 30B A3B Instruct | AtlasCloud | No |
| Qwen: Qwen3 VL 30B A3B Thinking | SiliconFlow | No |
| Qwen: Qwen3 VL 30B A3B Thinking | Novita | No |
| Qwen: Qwen3 VL 8B Instruct | Parasail | No |
| Qwen: Qwen3 VL 8B Instruct | Novita | No |
| Qwen: Qwen3 VL 8B Instruct | Together | No |
| Qwen: Qwen3 VL 8B Instruct | AtlasCloud | No |
| Qwen: Qwen3.5 397B A17B | Novita | No |
| Qwen: Qwen3.5 397B A17B | Together | No |
| Qwen: Qwen3.5 397B A17B | Parasail | No |
| Qwen: Qwen3.5 397B A17B | AtlasCloud | No |
| Qwen: Qwen3.5 397B A17B | Nebius | No |
| Qwen: Qwen3.5-122B-A10B | AtlasCloud | No |
| Qwen: Qwen3.5-122B-A10B | Novita | No |
| Qwen: Qwen3.5-27B | Phala | No |
| Qwen: Qwen3.5-27B | AtlasCloud | No |
| Qwen: Qwen3.5-27B | Novita | No |
| Qwen: Qwen3.5-35B-A3B | AkashML | No |
| Qwen: Qwen3.5-35B-A3B | Parasail | No |
| Qwen: Qwen3.5-35B-A3B | Venice | No |
| Qwen: Qwen3.5-35B-A3B | AtlasCloud | No |
| Qwen: Qwen3.5-35B-A3B | NextBit | No |
| Qwen: Qwen3.5-9B | Together | No |
| Qwen: Qwen3.5-9B | Venice | No |
| Qwen: QwQ 32B | SiliconFlow | No |
| Qwen2.5 72B Instruct | DeepInfra | No |
| Qwen2.5 72B Instruct | Novita | No |
| Reka Edge | Reka | No |
| Reka Flash 3 | Reka | No |
| Relace: Relace Apply 3 | Relace | No |
| Relace: Relace Search | Relace | No |
| ReMM SLERP 13B | Mancer 2 | No |
| ReMM SLERP 13B | NextBit | No |
| Sao10K: Llama 3 8B Lunaris | Novita | No |
| Sao10K: Llama 3 8B Lunaris | DeepInfra | No |
| Sao10k: Llama 3 Euryale 70B v2.1 | Novita | No |
| Sao10K: Llama 3.1 70B Hanami x1 | Infermatic | No |
| Sao10K: Llama 3.1 Euryale 70B v2.2 | Novita | No |
| Sao10K: Llama 3.1 Euryale 70B v2.2 | DeepInfra | No |
| Sao10K: Llama 3.3 Euryale 70B | NextBit | No |
| Sao10K: Llama 3.3 Euryale 70B | DeepInfra | No |
| Sentence Transformers: all-MiniLM-L12-v2 | DeepInfra | No |
| Sentence Transformers: all-MiniLM-L6-v2 | DeepInfra | No |
| Sentence Transformers: all-mpnet-base-v2 | DeepInfra | No |
| Sentence Transformers: multi-qa-mpnet-base-dot-v1 | DeepInfra | No |
| Sentence Transformers: paraphrase-MiniLM-L6-v2 | DeepInfra | No |
| StepFun: Step 3.5 Flash | SiliconFlow | No |
| StepFun: Step 3.5 Flash | DeepInfra | No |
| Tencent: Hunyuan A13B Instruct | SiliconFlow | No |
| TheDrummer: Cydonia 24B V4.1 | Parasail | No |
| TheDrummer: Rocinante 12B | NextBit | No |
| TheDrummer: Rocinante 12B | Infermatic | No |
| TheDrummer: Skyfall 36B V2 | Parasail | No |
| TheDrummer: UnslopNemo 12B | NextBit | No |
| Thenlper: GTE-Base | DeepInfra | No |
| Thenlper: GTE-Large | DeepInfra | No |
| Tongyi DeepResearch 30B A3B | AtlasCloud | No |
| Upstage: Solar Pro 3 | Upstage | No |
| Venice: Uncensored | Venice | No |
| WizardLM-2 8x22B | Novita | No |
| Writer: Palmyra X5 | Amazon Bedrock | No |
| Xiaomi: MiMo-V2-Flash | Novita | No |
| Xiaomi: MiMo-V2-Flash | AtlasCloud | No |
| Z.ai: GLM 4 32B | Z.AI | No |
| Z.ai: GLM 4.5 | Novita | No |
| Z.ai: GLM 4.5 | Z.AI | No |
| Z.ai: GLM 4.5 | Nebius | No |
| Z.ai: GLM 4.5 Air | Z.AI | No |
| Z.ai: GLM 4.5 Air | SiliconFlow | No |
| Z.ai: GLM 4.5 Air | Z.AI | No |
| Z.ai: GLM 4.5 Air | Novita | No |
| Z.ai: GLM 4.5 Air | Nebius | No |
| Z.ai: GLM 4.5V | Z.AI | Yes |
| Z.ai: GLM 4.5V | Novita | No |
| Z.ai: GLM 4.6 | BaseTen | No |
| Z.ai: GLM 4.6 | Novita | No |
| Z.ai: GLM 4.6 | DeepInfra | No |
| Z.ai: GLM 4.6 | Z.AI | No |
| Z.ai: GLM 4.6 | SiliconFlow | No |
| Z.ai: GLM 4.6 | AtlasCloud | No |
| Z.ai: GLM 4.6V | SiliconFlow | No |
| Z.ai: GLM 4.6V | DeepInfra | No |
| Z.ai: GLM 4.6V | Z.AI | Yes |
| Z.ai: GLM 4.6V | Novita | No |
| Z.ai: GLM 4.7 | SiliconFlow | No |
| Z.ai: GLM 4.7 | Z.AI | No |
| Z.ai: GLM 4.7 | Parasail | No |
| Z.ai: GLM 4.7 | DeepInfra | No |
| Z.ai: GLM 4.7 | Google | No |
| Z.ai: GLM 4.7 | Novita | No |
| Z.ai: GLM 4.7 | Venice | No |
| Z.ai: GLM 4.7 | Nebius | No |
| Z.ai: GLM 4.7 | AtlasCloud | No |
| Z.ai: GLM 4.7 | Cerebras | No |
| Z.ai: GLM 4.7 Flash | Novita | No |
| Z.ai: GLM 4.7 Flash | Z.AI | No |
| Z.ai: GLM 4.7 Flash | Phala | No |
| Z.ai: GLM 4.7 Flash | DeepInfra | No |
| Z.ai: GLM 4.7 Flash | Venice | No |
| Z.ai: GLM 5 | Parasail | No |
| Z.ai: GLM 5 | Venice | No |
| Z.ai: GLM 5 | Phala | No |
| Z.ai: GLM 5 | Novita | No |
| Z.ai: GLM 5 | DeepInfra | No |
| Z.ai: GLM 5 | SiliconFlow | No |
| Z.ai: GLM 5 | StreamLake | No |
| Z.ai: GLM 5 | Z.AI | No |
| Z.ai: GLM 5 | Venice | No |
| Z.ai: GLM 5 | Fireworks | No |
| Z.ai: GLM 5 | Together | No |
| Z.ai: GLM 5 | BaseTen | No |
| Z.ai: GLM 5 | AtlasCloud | No |
| Z.ai: GLM 5 Turbo | Z.AI | No |
| Z.ai: GLM 5 Turbo | AtlasCloud | No |
| Z.ai: GLM 5V Turbo | Z.AI | No |

Ask AI

Assistant

Responses are generated using AI and may contain mistakes.

Hi, I'm an AI assistant with access to documentation and other content.

Tip: You can toggle this pane with

`⌘`

+

`/`