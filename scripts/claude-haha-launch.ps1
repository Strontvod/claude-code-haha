param(
  [Parameter(ValueFromRemainingArguments = $true)]
  [string[]]$ClaudeArgs
)

$ErrorActionPreference = "Stop"

function Test-PortListening {
  param([int]$Port)
  $conn = Get-NetTCPConnection -LocalPort $Port -State Listen -ErrorAction SilentlyContinue
  return $null -ne $conn
}

function Start-OllamaIfNeeded {
  if (Test-PortListening -Port 11434) {
    return
  }

  $ollamaCmd = Get-Command ollama -ErrorAction SilentlyContinue
  if ($ollamaCmd) {
    Start-Process -FilePath $ollamaCmd.Source -ArgumentList "serve" -WindowStyle Hidden | Out-Null
    Start-Sleep -Seconds 2
    return
  }

  $fallback = "C:\Users\schep\AppData\Local\Programs\Ollama\ollama.exe"
  if (Test-Path $fallback) {
    Start-Process -FilePath $fallback -ArgumentList "serve" -WindowStyle Hidden | Out-Null
    Start-Sleep -Seconds 2
    return
  }

  throw "Ollama is not installed. Install with: winget install --id Ollama.Ollama -e"
}

function Start-ProxyIfNeeded {
  param([string]$RepoRoot)
  if (Test-PortListening -Port 4000) {
    return
  }

  Start-Process -FilePath "powershell" -ArgumentList @(
    "-NoProfile",
    "-Command",
    "Set-Location '$RepoRoot'; bun run local-llm:proxy"
  ) -WindowStyle Hidden | Out-Null

  Start-Sleep -Seconds 2
}

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Split-Path -Parent $ScriptDir
$EntryPoint = Join-Path $RepoRoot "src\entrypoints\cli.tsx"
$EnvFile = Join-Path $RepoRoot ".env"
$PreloadFile = Join-Path $RepoRoot "preload.ts"

if (-not (Get-Command bun -ErrorAction SilentlyContinue)) {
  throw "Bun is required. Install from https://bun.sh"
}

if (-not (Test-Path $EntryPoint)) {
  throw "Cannot find entrypoint: $EntryPoint"
}

if (-not (Test-Path $EnvFile)) {
  throw "Cannot find .env: $EnvFile"
}

if (-not (Test-Path $PreloadFile)) {
  throw "Cannot find preload file: $PreloadFile"
}

# Safety: prefer local-only auth path.
Remove-Item Env:CLAUDE_CODE_OAUTH_TOKEN -ErrorAction SilentlyContinue
Remove-Item Env:CLAUDE_CODE_OAUTH_TOKEN_FILE_DESCRIPTOR -ErrorAction SilentlyContinue
Remove-Item Env:ANTHROPIC_AUTH_TOKEN -ErrorAction SilentlyContinue

# Dedicated config home (plugins, MCP user config, sessions) — avoids sharing bloated %USERPROFILE%\.claude with official CLI.
# Override: set CLAUDE_CONFIG_DIR in the environment or in repo .env before starting (or set to %USERPROFILE%\.claude to share).
if ([string]::IsNullOrWhiteSpace([Environment]::GetEnvironmentVariable('CLAUDE_CONFIG_DIR', 'Process'))) {
  $dedicated = Join-Path $env:USERPROFILE '.claude-haha'
  if (-not (Test-Path -LiteralPath $dedicated)) {
    New-Item -ItemType Directory -Path $dedicated -Force | Out-Null
  }
  $env:CLAUDE_CONFIG_DIR = $dedicated
}

Start-OllamaIfNeeded
Start-ProxyIfNeeded -RepoRoot $RepoRoot

# Run in current working directory so each project is the active workspace.
# No default --bare: enables marketplace plugins, MCP (.mcp.json, user config), LSP, hooks. Pass --bare for minimal mode.
& bun --preload="$PreloadFile" --env-file="$EnvFile" "$EntryPoint" @ClaudeArgs
