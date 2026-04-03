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

# Put shims on the user PATH so `claude-haha` works without loading a profile
# (PowerShell 7 vs 5.1 use different profiles; PATH works in both).
$userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
if ($userPath -notlike "*$UserBin*") {
  $newPath = if ([string]::IsNullOrWhiteSpace($userPath)) { $UserBin } else { "$userPath;$UserBin" }
  try {
    [Environment]::SetEnvironmentVariable('Path', $newPath, 'User')
    Write-Host "Appended to user PATH: $UserBin"
    $env:Path = "$env:Path;$UserBin"
  } catch {
    Write-Host "Could not update user PATH; add manually: $UserBin"
  }
} else {
  Write-Host "User PATH already contains: $UserBin"
}

$markerStart = "# >>> claude-haha launcher >>>"
$markerEnd = "# <<< claude-haha launcher <<<"
$profileInstalled = $false

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

function Install-LauncherProfileBlock {
  param([string]$ProfilePath)
  if ([string]::IsNullOrWhiteSpace($ProfilePath)) { return $false }
  try {
    $dir = Split-Path -Parent $ProfilePath
    if ($dir) {
      [System.IO.Directory]::CreateDirectory($dir) | Out-Null
    }
    if (-not (Test-Path -LiteralPath $ProfilePath)) {
      New-Item -Path $ProfilePath -ItemType File -Force | Out-Null
    }
    $profileContent = Get-Content -LiteralPath $ProfilePath -Raw -ErrorAction SilentlyContinue
    if ($null -eq $profileContent) { $profileContent = "" }
    if ($profileContent -match [regex]::Escape($markerStart)) {
      $pattern = "(?s)$([regex]::Escape($markerStart)).*?$([regex]::Escape($markerEnd))"
      $newContent = [regex]::Replace($profileContent, $pattern, $block)
      Set-Content -Path $ProfilePath -Value $newContent -Encoding utf8
      Write-Host "Updated launcher block in $ProfilePath"
    } else {
      Add-Content -Path $ProfilePath -Value "`r`n$block`r`n" -Encoding utf8
      Write-Host "Installed launcher block in $ProfilePath"
    }
    return $true
  } catch {
    Write-Host "Profile update skipped for ${ProfilePath}: $_"
    return $false
  }
}

# This host's profile (Windows PowerShell 5.1 or pwsh, depending who ran the script)
if (Install-LauncherProfileBlock -ProfilePath $PROFILE) {
  $profileInstalled = $true
}

# PowerShell 7 profile is a different file; install there too when pwsh exists
$pwsh = Get-Command pwsh -ErrorAction SilentlyContinue
if ($pwsh) {
  $pwshProfile = & pwsh -NoProfile -NoLogo -Command 'Write-Output $PROFILE' 2>$null
  if ($pwshProfile -and ($pwshProfile -ne $PROFILE)) {
    if (Install-LauncherProfileBlock -ProfilePath $pwshProfile) {
      $profileInstalled = $true
    }
  }
}

Write-Host ""
Write-Host "Done. Open a new terminal and run:"
Write-Host "  claude-haha"
Write-Host "or short alias:"
Write-Host "  ch"
Write-Host ""
Write-Host "If the shell says 'not recognized' (old session / Cursor tab), refresh PATH:"
Write-Host '  $env:Path = [Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [Environment]::GetEnvironmentVariable("Path","User")'
Write-Host "Or run the shim by name:"
Write-Host "  claude-haha.cmd"
Write-Host "Or call the launcher directly:"
Write-Host "  & `"$Launcher`""
if (-not $profileInstalled) {
  Write-Host ""
  Write-Host "Note: profile alias install skipped; CMD shims still work via PATH."
}
