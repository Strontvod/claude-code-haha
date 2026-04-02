# Local LLM Backend (Fresh Rebuild)

This folder contains a clean local backend stack for `claude-code-haha`:

- `upstream/mock-openai-server.ts` (port `8080`)
  - OpenAI-compatible local upstream for testing.
- `proxy/server.ts` (port `4000`)
  - Anthropic-compatible proxy used by Claude Haha.
  - Bridges `POST /v1/messages` to either:
    - OpenAI-compatible upstream (`/v1/chat/completions`)
    - Ollama native upstream (`/api/chat`)

## Quick Start (Windows PowerShell)

Run these in separate terminals from repo root.

### 1) Real engine path (Ollama)

Install Ollama once:

```powershell
winget install --id Ollama.Ollama -e --accept-package-agreements --accept-source-agreements
```

Start Ollama (if not already running) and pull **one** model (recommended for ~12GB VRAM, e.g. RTX 3080 Ti: **Qwen3.5 9B**):

```powershell
ollama pull qwen3.5:9b
```

Ollama ships **one efficient (GGUF-class) build per tag**—you pick a single tag like `:9b`, not a long list of quant files. Library: [qwen3.5 on Ollama](https://ollama.com/library/qwen3.5).

The proxy sends **`think: false`** to Ollama by default (faster). Set **`LOCAL_LLM_OLLAMA_THINK=1`** to enable chain-of-thought; when Ollama returns `message.thinking`, the proxy prepends it under a `Thinking:` header so it shows in Claude Code. In the shell: `ollama run qwen3.5:9b --think=false "say ok"` turns thinking off for a one-off run.

Set the same id in `.env` (all four lines should match):

```env
ANTHROPIC_MODEL=qwen3.5:9b
ANTHROPIC_DEFAULT_SONNET_MODEL=qwen3.5:9b
ANTHROPIC_DEFAULT_HAIKU_MODEL=qwen3.5:9b
ANTHROPIC_DEFAULT_OPUS_MODEL=qwen3.5:9b
LOCAL_LLM_UPSTREAM=http://127.0.0.1:11434
LOCAL_LLM_UPSTREAM_PROVIDER=ollama
```

Optional **code-tuned** alternative (larger on disk ~9GB): `ollama pull qwen2.5-coder:14b` and set all four `ANTHROPIC_*` lines to `qwen2.5-coder:14b`.

### 2) Start Anthropic-compatible proxy

```powershell
bun run local-llm:proxy
```

### 3) Start Claude Haha

```powershell
bun --env-file=.env ./src/entrypoints/cli.tsx
```

Add `--bare` only if you want minimal mode (no auto MCP/plugins, no CLAUDE.md discovery).

## Config folder (plugins, MCP, sessions)

The Windows launcher and `bin/claude-haha` default to **`%USERPROFILE%\.claude-haha`** via `CLAUDE_CONFIG_DIR`, so local runs stay separate from the official **`\.claude`** install (less bloat, different plugins/MCP). To share one config with Anthropic’s CLI, set `CLAUDE_CONFIG_DIR` to **`%USERPROFILE%\.claude`** in your environment or repo `.env`.

## Use From Any Project (VSCode/Cursor)

Install a PowerShell launcher once:

```powershell
bun run launcher:install
```

Open a new terminal, then from any project folder run:

```powershell
claude-haha
```

Or short alias:

```powershell
ch
```

The launcher will:

- auto-start Ollama if not already running
- auto-start proxy if not already running
- run Claude Haha in your current folder with **plugins + MCP** enabled (same as omitting `--bare`). Use `claude-haha --bare` for the old minimal mode.

## Doctor Command

Run a full health check:

```powershell
bun run launcher:doctor
```

Run health check with auto-fix (start missing services):

```powershell
bun run launcher:doctor:fix
```

## Optional: mock upstream (for testing only)

### 1) Start upstream (mock)

```powershell
bun run local-llm:upstream:mock
```

### 2) Override `.env` for mock

```env
LOCAL_LLM_UPSTREAM=http://127.0.0.1:8080
LOCAL_LLM_UPSTREAM_PROVIDER=openai
ANTHROPIC_MODEL=local-dev-model
ANTHROPIC_DEFAULT_SONNET_MODEL=local-dev-model
ANTHROPIC_DEFAULT_HAIKU_MODEL=local-dev-model
ANTHROPIC_DEFAULT_OPUS_MODEL=local-dev-model
```

### 3) Start Anthropic-compatible proxy

```powershell
bun run local-llm:proxy
```

### 4) Start Claude Haha

```powershell
bun --env-file=.env ./src/entrypoints/cli.tsx
```

(Optional: append `--bare` for a stricter minimal session while testing mock upstream.)

## Health Checks

```powershell
Invoke-WebRequest -UseBasicParsing http://127.0.0.1:4000/health
```

## Ollama app: latest catalog

- **Update the app (Windows):** `winget upgrade --id Ollama.Ollama -e --accept-package-agreements --accept-source-agreements`
- **Refresh the model picker:** fully quit and reopen Ollama; the list comes from ollama.com.

## Notes

- Keep proxy at `:4000`; only switch `LOCAL_LLM_UPSTREAM*` as needed.
