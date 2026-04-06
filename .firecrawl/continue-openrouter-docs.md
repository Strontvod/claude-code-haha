ChecksCLIIDE Extensions

# How to Configure OpenRouter with Continue

Copy page

**Discover OpenRouter models [here](https://continue.dev/openrouter)**

Get an API key from [OpenRouter](https://openrouter.ai/keys)

YAMLJSON (Deprecated)

```yaml
name: My Config
version: 0.0.1
schema: v1

models:
  - name: <MODEL_NAME>
    provider: openrouter
    model: <MODEL_ID>
    apiBase: https://openrouter.ai/api/v1
    apiKey: <YOUR_OPEN_ROUTER_API_KEY>
```

**Check out a more advanced configuration [here](https://continue.dev/openrouter/qwen3-coder?view=config)**

## [Optional configuration](https://docs.continue.dev/customize/model-providers/top-level/openrouter\#optional-configuration)

OpenRouter allows you configure provider preferences, model routing configuration, and more. You can set these via `requestOptions`.

For example, to prevent extra long prompts from being compressed, you can explicitly turn off [Transforms](https://openrouter.ai/docs/features/message-transforms):)

YAMLJSON (Deprecated)

```yaml
name: My Config
version: 0.0.1
schema: v1

models:
  - name: <MODEL_NAME>
    provider: openrouter
    model: <MODEL_ID>
    requestOptions:
      extraBodyProperties:
        transforms: []
```

## [Model Capabilities](https://docs.continue.dev/customize/model-providers/top-level/openrouter\#model-capabilities)

OpenRouter models may require explicit capability configuration because the proxy doesn't always preserve the function calling support of the original model.

Continue automatically uses system message tools for models that don't support
native function calling, so Agent mode should work even without explicit
capability configuration. However, you can still override capabilities if
needed.

If you're experiencing issues with Agent mode or tools not working, you can add the capabilities field:

YAMLJSON (Deprecated)

```yaml
name: My Config
version: 0.0.1
schema: v1

models:
  - name: <MODEL_NAME>
    provider: openrouter
    model: <MODEL_ID>
    apiBase: https://openrouter.ai/api/v1
    apiKey: <YOUR_OPEN_ROUTER_API_KEY>
    capabilities:
      - tool_use      # Enable function calling for Agent mode
```

Not all models support function calling. Check the [OpenRouter models page](https://openrouter.ai/models) for specific model capabilities.

[Ollama](https://docs.continue.dev/customize/model-providers/top-level/ollama) [OpenAI](https://docs.continue.dev/customize/model-providers/top-level/openai)