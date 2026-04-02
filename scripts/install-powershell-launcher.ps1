$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Split-Path -Parent $ScriptDir
$Launcher = Join-Path $RepoRoot "scripts\claude-haha-launch.ps1"
$UserBin = Join-Path $HOME ".bun\bin"
$CmdShim = Join-Path $UserBin "claude-haha.cmd"
$ShortShim = Join-Path $UserBin "ch.cmd"

if (-not (Test-Path $Launcher)) {
  throw "Launcher script not found: $Launcher"
}

if (-not (Test-Path $UserBin)) {
  New-Item -Path $UserBin -ItemType Directory -Force | Out-Null
}

$cmdContent = @"
@echo off
powershell -NoProfile -ExecutionPolicy Bypass -File "$Launcher" %*
"@

$shortContent = @"
@echo off
claude-haha %*
"@

Set-Content -Path $CmdShim -Value $cmdContent
Set-Content -Path $ShortShim -Value $shortContent
Write-Host "Installed command shims:"
Write-Host "  $CmdShim"
Write-Host "  $ShortShim"
Write-Host ""
Write-Host "Make sure '$UserBin' is in PATH."
Write-Host ""

$markerStart = "# >>> claude-haha launcher >>>"
$markerEnd = "# <<< claude-haha launcher <<<"
$profileInstalled = $false

try {
  if (-not (Test-Path $PROFILE)) {
    New-Item -Path $PROFILE -ItemType File -Force | Out-Null
  }
  $profileContent = Get-Content $PROFILE -Raw
} catch {
  $profileContent = ""
}

$block = @"
$markerStart
function claude-haha {
  param(
    [Parameter(ValueFromRemainingArguments = `$true)]
    [string[]]`$Args
  )
  & "$Launcher" @Args
}
Set-Alias ch claude-haha
$markerEnd
"@

if ($profileContent) {
  try {
    if ($profileContent -match [regex]::Escape($markerStart)) {
      $pattern = "(?s)$([regex]::Escape($markerStart)).*?$([regex]::Escape($markerEnd))"
      $newContent = [regex]::Replace($profileContent, $pattern, $block)
      Set-Content -Path $PROFILE -Value $newContent
      Write-Host "Updated existing launcher block in $PROFILE"
    } else {
      Add-Content -Path $PROFILE -Value "`r`n$block`r`n"
      Write-Host "Installed launcher block in $PROFILE"
    }
    $profileInstalled = $true
  } catch {
    Write-Host "Profile update skipped (file lock or permissions)."
  }
}

Write-Host ""
Write-Host "Done. Open a new terminal and run:"
Write-Host "  claude-haha"
Write-Host "or short alias:"
Write-Host "  ch"
if (-not $profileInstalled) {
  Write-Host ""
  Write-Host "Note: profile alias install skipped; CMD shims still work via PATH."
}
