param(
  [switch]$Fix
)

$ErrorActionPreference = "Stop"

$passCount = 0
$warnCount = 0
$failCount = 0

function Pass([string]$msg) {
  $script:passCount++
  Write-Host "[PASS] $msg" -ForegroundColor Green
}

function Warn([string]$msg) {
  $script:warnCount++
  Write-Host "[WARN] $msg" -ForegroundColor Yellow
}

function Fail([string]$msg) {
  $script:failCount++
  Write-Host "[FAIL] $msg" -ForegroundColor Red
}

function Test-PortListening([int]$Port) {
  return $null -ne (Get-NetTCPConnection -LocalPort $Port -State Listen -ErrorAction SilentlyContinue)
}

function Read-EnvMap([string]$Path) {
  $map = @{}
  if (-not (Test-Path $Path)) {
    return $map
  }
  Get-Content $Path | ForEach-Object {
    $line = $_.Trim()
    if (-not $line) { return }
    if ($line.StartsWith("#")) { return }
    if ($line -match '^\s*([A-Za-z_][A-Za-z0-9_]*)\s*=\s*(.*)\s*$') {
      $map[$matches[1]] = $matches[2]
    }
  }
  return $map
}

function Resolve-OllamaExe {
  $cmd = Get-Command ollama -ErrorAction SilentlyContinue
  if ($cmd) { return $cmd.Source }
  $fallback = Join-Path $HOME "AppData\Local\Programs\Ollama\ollama.exe"
  if (Test-Path $fallback) { return $fallback }
  return $null
}

function Start-Ollama([string]$OllamaExe) {
  Start-Process -FilePath $OllamaExe -ArgumentList "serve" -WindowStyle Hidden | Out-Null
  Start-Sleep -Seconds 2
}

function Start-Proxy([string]$RepoRoot) {
  Start-Process -FilePath "powershell" -ArgumentList @(
    "-NoProfile",
    "-Command",
    "Set-Location '$RepoRoot'; bun run local-llm:proxy"
  ) -WindowStyle Hidden | Out-Null
  Start-Sleep -Seconds 2
}

Write-Host "=== Claude Haha Doctor ===" -ForegroundColor Cyan
Write-Host "Fix mode: $Fix"
Write-Host ""

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Split-Path -Parent $scriptDir
$envFile = Join-Path $repoRoot ".env"
$preloadFile = Join-Path $repoRoot "preload.ts"
$entryFile = Join-Path $repoRoot "src\entrypoints\cli.tsx"
$proxyFile = Join-Path $repoRoot "local-llm\proxy\server.ts"

if (Test-Path $envFile) { Pass ".env found: $envFile" } else { Fail ".env missing: $envFile" }
if (Test-Path $preloadFile) { Pass "preload file found" } else { Fail "preload file missing" }
if (Test-Path $entryFile) { Pass "entrypoint found" } else { Fail "entrypoint missing" }
if (Test-Path $proxyFile) { Pass "proxy server file found" } else { Fail "proxy server file missing" }

if (Get-Command bun -ErrorAction SilentlyContinue) {
  Pass "bun is available"
} else {
  Fail "bun not found in PATH"
}

$ollamaExe = Resolve-OllamaExe
if ($ollamaExe) {
  Pass "ollama executable found: $ollamaExe"
} else {
  Fail "ollama not found (install: winget install --id Ollama.Ollama -e)"
}

$envMap = Read-EnvMap $envFile
$anthropicBase = $envMap["ANTHROPIC_BASE_URL"]
$upstream = $envMap["LOCAL_LLM_UPSTREAM"]
$provider = $envMap["LOCAL_LLM_UPSTREAM_PROVIDER"]
$model = $envMap["ANTHROPIC_MODEL"]

if ($anthropicBase -eq "http://127.0.0.1:4000") {
  Pass "ANTHROPIC_BASE_URL is local proxy"
} else {
  Warn "ANTHROPIC_BASE_URL is '$anthropicBase' (expected http://127.0.0.1:4000)"
}

if ($upstream -eq "http://127.0.0.1:11434") {
  Pass "LOCAL_LLM_UPSTREAM points to Ollama"
} else {
  Warn "LOCAL_LLM_UPSTREAM is '$upstream' (expected http://127.0.0.1:11434)"
}

if ($provider -eq "ollama") {
  Pass "LOCAL_LLM_UPSTREAM_PROVIDER is ollama"
} else {
  Warn "LOCAL_LLM_UPSTREAM_PROVIDER is '$provider' (expected ollama)"
}

if ([string]::IsNullOrWhiteSpace($model)) {
  Fail "ANTHROPIC_MODEL is empty"
} else {
  Pass "ANTHROPIC_MODEL is set: $model"
}

if ($ollamaExe) {
  if (-not (Test-PortListening 11434)) {
    if ($Fix) {
      Write-Host "Starting Ollama service..." -ForegroundColor DarkCyan
      Start-Ollama $ollamaExe
    }
  }

  if (Test-PortListening 11434) {
    Pass "port 11434 listening (Ollama)"
  } else {
    Fail "port 11434 not listening"
  }
}

if (-not (Test-PortListening 4000)) {
  if ($Fix) {
    Write-Host "Starting local proxy..." -ForegroundColor DarkCyan
    Start-Proxy $repoRoot
  }
}

if (Test-PortListening 4000) {
  Pass "port 4000 listening (proxy)"
} else {
  Fail "port 4000 not listening"
}

try {
  $ollamaTags = Invoke-RestMethod -Uri "http://127.0.0.1:11434/api/tags" -TimeoutSec 10
  $models = @($ollamaTags.models | ForEach-Object { $_.name })
  Pass "Ollama API reachable"
  if ($model -and $models -contains $model) {
    Pass "configured model exists in Ollama: $model"
  } else {
    Warn "configured model not found in Ollama list: $model"
    if ($models.Count -gt 0) {
      Write-Host "Available models: $($models -join ', ')" -ForegroundColor DarkYellow
    } else {
      Warn "no models currently installed in Ollama"
    }
  }
} catch {
  Fail "Ollama API not reachable: $($_.Exception.Message)"
}

try {
  $proxyHealth = Invoke-RestMethod -Uri "http://127.0.0.1:4000/health" -TimeoutSec 10
  Pass "proxy health reachable"
  if ($proxyHealth.upstream) {
    Pass "proxy upstream: $($proxyHealth.upstream)"
  }
} catch {
  Fail "proxy health failed: $($_.Exception.Message)"
}

if ($model) {
  try {
    $headers = @{
      "x-api-key" = "local-dev-key"
      "anthropic-version" = "2023-06-01"
      "content-type" = "application/json"
    }
    $body = @{
      model = $model
      max_tokens = 16
      messages = @(@{ role = "user"; content = "Reply with DOCTOR_OK only" })
    } | ConvertTo-Json -Depth 8
    $resp = Invoke-RestMethod -Method Post -Uri "http://127.0.0.1:4000/v1/messages?beta=true" -Headers $headers -Body $body -TimeoutSec 90
    $text = @($resp.content | Where-Object { $_.type -eq "text" } | ForEach-Object { $_.text }) -join " "
    Pass "proxy -> model inference call succeeded"
    Write-Host "Model response: $text" -ForegroundColor DarkGray
  } catch {
    Fail "proxy -> model inference failed: $($_.Exception.Message)"
  }
}

Write-Host ""
Write-Host "=== Doctor Summary ===" -ForegroundColor Cyan
Write-Host "PASS: $passCount" -ForegroundColor Green
Write-Host "WARN: $warnCount" -ForegroundColor Yellow
Write-Host "FAIL: $failCount" -ForegroundColor Red

if ($failCount -gt 0) {
  exit 1
}
exit 0
