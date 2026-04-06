[Skip to main content](https://docs.cline.bot/provider-config/openrouter#content-area)

[Cline home page![light logo](https://mintcdn.com/cline-efdc8260/tkBpPpnPdliQ8Wgu/assets/Cline_Logo-complete_black.png?fit=max&auto=format&n=tkBpPpnPdliQ8Wgu&q=85&s=e47e2108fe0ef7de1ae02704a8f5362c)![dark logo](https://mintcdn.com/cline-efdc8260/tkBpPpnPdliQ8Wgu/assets/Cline_Logo-complete_white.png?fit=max&auto=format&n=tkBpPpnPdliQ8Wgu&q=85&s=c93d709cb4f8b09e8436b479ce91a0c8)](https://docs.cline.bot/)

Search Cline documentation...

Ctrl K

Search...

Navigation

Cloud Providers

OpenRouter

[Docs](https://docs.cline.bot/home) [Enterprise](https://docs.cline.bot/enterprise-solutions/overview) [API](https://docs.cline.bot/api/overview) [Kanban](https://docs.cline.bot/kanban/overview) [Learn](https://cline.bot/learn)

On this page

- [Getting an API Key](https://docs.cline.bot/provider-config/openrouter#getting-an-api-key)
- [Supported Models](https://docs.cline.bot/provider-config/openrouter#supported-models)
- [Configuration in Cline](https://docs.cline.bot/provider-config/openrouter#configuration-in-cline)
- [Supported Transforms](https://docs.cline.bot/provider-config/openrouter#supported-transforms)
- [Tips and Notes](https://docs.cline.bot/provider-config/openrouter#tips-and-notes)

OpenRouter is an AI platform that provides access to a wide variety of language models from different providers, all through a single API. This can simplify setup and allow you to easily experiment with different models.**Website:** [https://openrouter.ai/](https://openrouter.ai/)

### [​](https://docs.cline.bot/provider-config/openrouter\#getting-an-api-key)  Getting an API Key

1. **Sign Up/Sign In:** Go to the [OpenRouter website](https://openrouter.ai/). Sign in with your Google or GitHub account.
2. **Get an API Key:** Go to the [keys page](https://openrouter.ai/keys). You should see an API key listed. If not, create a new key.
3. **Copy the Key:** Copy the API key.

### [​](https://docs.cline.bot/provider-config/openrouter\#supported-models)  Supported Models

OpenRouter supports a large and growing number of models. Cline automatically fetches the list of available models. Refer to the [OpenRouter Models page](https://openrouter.ai/models) for the complete and up-to-date list.

### [​](https://docs.cline.bot/provider-config/openrouter\#configuration-in-cline)  Configuration in Cline

1. **Open Cline Settings:** Click the settings icon (⚙️) in the Cline panel.
2. **Select Provider:** Choose “OpenRouter” from the “API Provider” dropdown.
3. **Enter API Key:** Paste your OpenRouter API key into the “OpenRouter API Key” field.
4. **Select Model:** Choose your desired model from the “Model” dropdown.
5. **(Optional) Custom Base URL:** If you need to use a custom base URL for the OpenRouter API, check “Use custom base URL” and enter the URL. Leave this blank for most users.

### [​](https://docs.cline.bot/provider-config/openrouter\#supported-transforms)  Supported Transforms

OpenRouter provides an [optional “middle-out” message transform](https://openrouter.ai/docs/features/message-transforms) to help with prompts that exceed the maximum context size of a model. You can enable it by checking the “Compress prompts and message chains to the context size” box.

### [​](https://docs.cline.bot/provider-config/openrouter\#tips-and-notes)  Tips and Notes

- **Model Selection:** OpenRouter offers a wide range of models. Experiment to find the best one for your needs.
- **Pricing:** OpenRouter charges based on the underlying model’s pricing. See the [OpenRouter Models page](https://openrouter.ai/models) for details.
- **Prompt Caching:**
  - OpenRouter passes caching requests to underlying models that support it. Check the [OpenRouter Models page](https://openrouter.ai/models) to see which models offer caching.
  - For most models, caching should activate automatically if supported by the model itself (similar to how Requesty works).
  - **Exception for Gemini Models via OpenRouter:** Due to potential response delays sometimes observed with Google’s caching mechanism when accessed via OpenRouter, a manual activation step is required _specifically for Gemini models_.
  - If using a **Gemini model** via OpenRouter, you **must manually check** the “Enable Prompt Caching” box in the provider settings to activate caching for that model. This checkbox serves as a temporary workaround. For non-Gemini models on OpenRouter, this checkbox is not necessary for caching.

Was this page helpful?

YesNo

[OpenAI Codex](https://docs.cline.bot/provider-config/openai-codex) [Oracle Code Assist](https://docs.cline.bot/provider-config/oracle-code-assist)

Ctrl+I