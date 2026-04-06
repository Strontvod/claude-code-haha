param(
  [switch]$Fix,
  [string]$EnvFile
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
      $map[$matches[1]] = $matches[2].Trim().Trim('"').Trim("'")
    }
  }
  return $map
}

function Normalize-PathForComparison([string]$PathValue) {
  return ([System.IO.Path]::GetFullPath($PathValue)).TrimEnd('\', '/').ToLowerInvariant()
}

function Resolve-ClaudeConfigDir([hashtable]$EnvMap) {
  if (-not [string]::IsNullOrWhiteSpace($env:CLAUDE_CONFIG_DIR)) {
    return $env:CLAUDE_CONFIG_DIR
  }
  if ($EnvMap.ContainsKey("CLAUDE_CONFIG_DIR") -and -not [string]::IsNullOrWhiteSpace($EnvMap["CLAUDE_CONFIG_DIR"])) {
    return $EnvMap["CLAUDE_CONFIG_DIR"]
  }
  return (Join-Path $HOME ".claude-haha")
}

function Is-OfficialClaudeConfigDir([string]$ConfigDir) {
  $officialDir = Join-Path $HOME ".claude"
  return (Normalize-PathForComparison $ConfigDir) -eq (Normalize-PathForComparison $officialDir)
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

function Get-ProviderMode([string]$BaseUrl) {
  if ([string]::IsNullOrWhiteSpace($BaseUrl)) {
    return "anthropic-default"
  }
  if ($BaseUrl -match '^https://openrouter\.ai/api(?:/|$)') {
    return "openrouter"
  }
  if ($BaseUrl -match '^https://api\.fireworks\.ai(?:/|$)') {
    return "fireworks"
  }
  if ($BaseUrl -match '^http://(127\.0\.0\.1|localhost):4000(?:/|$)') {
    return "local-proxy"
  }
  try {
    $uri = [System.Uri]$BaseUrl
    $host = $uri.Host.ToLowerInvariant()
    if ($host -eq "openrouter.ai") {
      return "openrouter"
    }
    if ($host -eq "api.fireworks.ai") {
      return "fireworks"
    }
    if (($host -eq "127.0.0.1" -or $host -eq "localhost") -and $uri.Port -eq 4000 -and $uri.Scheme -eq "http") {
      return "local-proxy"
    }
    return "third-party-compatible"
  } catch {
    return "third-party-compatible"
  }
}

function Get-MessageText($Response) {
  return @($Response.content | Where-Object { $_.type -eq "text" } | ForEach-Object { $_.text }) -join " "
}

function Get-MessagesEndpoint([string]$BaseUrl) {
  return ($BaseUrl.TrimEnd('/')) + "/v1/messages"
}

Write-Host "=== Claude Haha Doctor ===" -ForegroundColor Cyan
Write-Host "Fix mode: $Fix"
Write-Host ""

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Split-Path -Parent $scriptDir
$resolvedEnvFile = if (-not [string]::IsNullOrWhiteSpace($EnvFile)) { $EnvFile } elseif (-not [string]::IsNullOrWhiteSpace($env:CLAUDE_HAHA_ENV_FILE)) { $env:CLAUDE_HAHA_ENV_FILE } else { Join-Path $repoRoot ".env" }
$preloadFile = Join-Path $repoRoot "preload.ts"
$entryFile = Join-Path $repoRoot "src\entrypoints\cli.tsx"
$proxyFile = Join-Path $repoRoot "local-llm\proxy\server.ts"

if (Test-Path $resolvedEnvFile) { Pass ".env found: $resolvedEnvFile" } else { Fail ".env missing: $resolvedEnvFile" }
if (Test-Path $preloadFile) { Pass "preload file found" } else { Fail "preload file missing" }
if (Test-Path $entryFile) { Pass "entrypoint found" } else { Fail "entrypoint missing" }
if (Test-Path $proxyFile) { Pass "proxy server file found" } else { Fail "proxy server file missing" }

if (Get-Command bun -ErrorAction SilentlyContinue) {
  Pass "bun is available"
} else {
  Fail "bun not found in PATH"
}

$envMap = Read-EnvMap $resolvedEnvFile
$anthropicBase = $envMap["ANTHROPIC_BASE_URL"]
$upstream = $envMap["LOCAL_LLM_UPSTREAM"]
$provider = $envMap["LOCAL_LLM_UPSTREAM_PROVIDER"]
$apiKey = $envMap["ANTHROPIC_API_KEY"]
$authToken = $envMap["ANTHROPIC_AUTH_TOKEN"]
$model = $envMap["ANTHROPIC_MODEL"]
$smallFastModel = $envMap["ANTHROPIC_SMALL_FAST_MODEL"]
$defaultSonnetModel = $envMap["ANTHROPIC_DEFAULT_SONNET_MODEL"]
$defaultHaikuModel = $envMap["ANTHROPIC_DEFAULT_HAIKU_MODEL"]
$defaultOpusModel = $envMap["ANTHROPIC_DEFAULT_OPUS_MODEL"]
$providerMode = Get-ProviderMode $anthropicBase
$configDir = Resolve-ClaudeConfigDir $envMap

Pass "detected provider mode: $providerMode"

if (Is-OfficialClaudeConfigDir $configDir) {
  Fail "CLAUDE_CONFIG_DIR points at the official global ~/.claude directory. claude-haha must stay isolated under ~/.claude-haha."
} else {
  Pass "isolated config dir: $configDir"
}

if ([string]::IsNullOrWhiteSpace($model)) {
  Fail "ANTHROPIC_MODEL is empty"
} else {
  Pass "ANTHROPIC_MODEL is set: $model"
}

switch ($providerMode) {
  "openrouter" {
    $expectedModel = "qwen/qwen3.6-plus:free"
    $expectedBase = "https://openrouter.ai/api"

    if ($anthropicBase -eq $expectedBase) {
      Pass "ANTHROPIC_BASE_URL is OpenRouter Anthropic-compatible endpoint"
    } else {
      Fail "ANTHROPIC_BASE_URL must be $expectedBase for the default OpenRouter setup"
    }

    if ([string]::IsNullOrWhiteSpace($authToken)) {
      Fail "ANTHROPIC_AUTH_TOKEN is required for OpenRouter"
    } else {
      Pass "ANTHROPIC_AUTH_TOKEN is set for OpenRouter"
    }

    if ([string]::IsNullOrWhiteSpace($apiKey)) {
      Pass "ANTHROPIC_API_KEY is empty for the default OpenRouter bearer-token setup"
    } else {
      Warn "ANTHROPIC_API_KEY is set; the default OpenRouter setup prefers ANTHROPIC_AUTH_TOKEN"
    }

    $modelChecks = @(
      @{ Name = "ANTHROPIC_MODEL"; Value = $model },
      @{ Name = "ANTHROPIC_SMALL_FAST_MODEL"; Value = $smallFastModel },
      @{ Name = "ANTHROPIC_DEFAULT_SONNET_MODEL"; Value = $defaultSonnetModel },
      @{ Name = "ANTHROPIC_DEFAULT_HAIKU_MODEL"; Value = $defaultHaikuModel },
      @{ Name = "ANTHROPIC_DEFAULT_OPUS_MODEL"; Value = $defaultOpusModel }
    )
    foreach ($check in $modelChecks) {
      if ($check.Value -eq $expectedModel) {
        Pass "$($check.Name) is pinned to qwen/qwen3.6-plus:free"
      } else {
        Fail "$($check.Name) must be $expectedModel"
      }
    }

    if ($envMap["CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS"] -eq "1") {
      Pass "CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS=1"
    } else {
      Warn "CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS is not 1; Anthropic-only betas may break OpenRouter compatibility"
    }

    if ($failCount -eq 0) {
      try {
        $headers = @{
          "Authorization" = "Bearer $authToken"
          "anthropic-version" = "2023-06-01"
          "content-type" = "application/json"
        }
        $body = @{
          model = $expectedModel
          max_tokens = 16
          messages = @(@{ role = "user"; content = "Reply with DOCTOR_OK only" })
        } | ConvertTo-Json -Depth 8
        $resp = Invoke-RestMethod -Method Post -Uri (Get-MessagesEndpoint $anthropicBase) -Headers $headers -Body $body -TimeoutSec 90
        $text = Get-MessageText $resp
        if (-not [string]::IsNullOrWhiteSpace($text)) {
          Pass "OpenRouter qwen/qwen3.6-plus:free inference call succeeded"
          if ($text -notmatch "DOCTOR_OK") {
            Warn "OpenRouter qwen/qwen3.6-plus:free returned non-empty text but did not echo DOCTOR_OK exactly"
          }
        } else {
          Fail "OpenRouter qwen/qwen3.6-plus:free inference returned an empty text response"
        }
      } catch {
        Fail "OpenRouter qwen/qwen3.6-plus:free inference failed: $($_.Exception.Message)"
      }
    }
  }
  "fireworks" {
    $expectedModel = "accounts/fireworks/models/glm-5"
    $expectedBase = "https://api.fireworks.ai/inference"

    if ($anthropicBase -eq $expectedBase) {
      Pass "ANTHROPIC_BASE_URL is Fireworks inference endpoint"
    } else {
      Fail "ANTHROPIC_BASE_URL must be $expectedBase for Fireworks GLM-5"
    }

    if ([string]::IsNullOrWhiteSpace($apiKey)) {
      Fail "ANTHROPIC_API_KEY is required for Fireworks"
    } else {
      Pass "ANTHROPIC_API_KEY is set for Fireworks"
    }

    if ([string]::IsNullOrWhiteSpace($authToken)) {
      Pass "ANTHROPIC_AUTH_TOKEN is unset for Fireworks API-key mode"
    } else {
      Warn "ANTHROPIC_AUTH_TOKEN is set; launcher will ignore it and prefer isolated API-key mode"
    }

    $modelChecks = @(
      @{ Name = "ANTHROPIC_MODEL"; Value = $model },
      @{ Name = "ANTHROPIC_SMALL_FAST_MODEL"; Value = $smallFastModel },
      @{ Name = "ANTHROPIC_DEFAULT_SONNET_MODEL"; Value = $defaultSonnetModel },
      @{ Name = "ANTHROPIC_DEFAULT_HAIKU_MODEL"; Value = $defaultHaikuModel },
      @{ Name = "ANTHROPIC_DEFAULT_OPUS_MODEL"; Value = $defaultOpusModel }
    )
    foreach ($check in $modelChecks) {
      if ($check.Value -eq $expectedModel) {
        Pass "$($check.Name) is pinned to GLM-5"
      } else {
        Fail "$($check.Name) must be $expectedModel"
      }
    }

    if ($envMap["CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS"] -eq "1") {
      Pass "CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS=1"
    } else {
      Warn "CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS is not 1; some Anthropic-only betas may break Fireworks compatibility"
    }

    if ($failCount -eq 0) {
      try {
        $headers = @{
          "x-api-key" = $apiKey
          "anthropic-version" = "2023-06-01"
          "content-type" = "application/json"
        }
        $body = @{
          model = $expectedModel
          max_tokens = 16
          messages = @(@{ role = "user"; content = "Reply with DOCTOR_OK only" })
        } | ConvertTo-Json -Depth 8
        $resp = Invoke-RestMethod -Method Post -Uri (Get-MessagesEndpoint $anthropicBase) -Headers $headers -Body $body -TimeoutSec 90
        $text = Get-MessageText $resp
        if (-not [string]::IsNullOrWhiteSpace($text)) {
          Pass "Fireworks GLM-5 inference call succeeded"
          if ($text -notmatch "DOCTOR_OK") {
            Warn "Fireworks GLM-5 returned non-empty text but did not echo DOCTOR_OK exactly"
          }
        } else {
          Fail "Fireworks GLM-5 inference returned an empty text response"
        }
      } catch {
        Fail "Fireworks GLM-5 inference failed: $($_.Exception.Message)"
      }
    }
  }
  "local-proxy" {
    $ollamaExe = Resolve-OllamaExe
    if ($ollamaExe) {
      Pass "ollama executable found: $ollamaExe"
    } else {
      Fail "ollama not found (install: winget install --id Ollama.Ollama -e)"
    }

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
        $text = Get-MessageText $resp
        if (-not [string]::IsNullOrWhiteSpace($text)) {
          Pass "proxy -> model inference call succeeded"
          if ($text -notmatch "DOCTOR_OK") {
            Warn "proxy -> model returned non-empty text but did not echo DOCTOR_OK exactly"
          }
        } else {
          Fail "proxy -> model inference returned an empty text response"
        }
      } catch {
        Fail "proxy -> model inference failed: $($_.Exception.Message)"
      }
    }
  }
  default {
    Warn "Doctor has full checks for OpenRouter, Fireworks GLM-5, and the local proxy stack. Current provider mode '$providerMode' only receives generic validation."
    if ([string]::IsNullOrWhiteSpace($anthropicBase)) {
      Pass "ANTHROPIC_BASE_URL is unset (default Anthropic endpoint)"
    } else {
      Pass "ANTHROPIC_BASE_URL is set: $anthropicBase"
    }
    if ([string]::IsNullOrWhiteSpace($apiKey) -and [string]::IsNullOrWhiteSpace($authToken)) {
      Fail "Set ANTHROPIC_API_KEY or ANTHROPIC_AUTH_TOKEN for the configured provider"
    } else {
      Pass "provider authentication variable is set"
    }
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
