---
name: Repair Windows Dev Environment
overview: Diagnose and repair the workstation-wide Python, PATH, Bash, and WSL configuration so PowerShell, Cursor, VS Code, and project terminals resolve a consistent toolchain. Standardize on a Windows-native Python workflow plus Git Bash and a real WSL distro, while isolating optional tools like Conda from the default shell path.
todos:
  - id: snapshot-current-state
    content: Back up PATH, shell resolution, and profile/terminal configuration before any system changes
    status: pending
  - id: standardize-python
    content: Repair Python Install Manager / py launcher and remove Miniconda from default global PATH resolution
    status: pending
  - id: repair-shells
    content: Install/configure a real WSL distro and make Git Bash the Windows bash resolver
    status: pending
  - id: clean-path-aliases
    content: Deduplicate PATH and disable only the Python-related execution aliases that still conflict
    status: pending
  - id: validate-workflows
    content: Verify Python, py, Bash, WSL, PowerShell, Cursor, and VS Code behavior end-to-end
    status: pending
isProject: false
---

# Windows Dev Environment Repair Plan

**Goal:** Make `python`, `py`, PowerShell, Git Bash, and WSL resolve predictably across all projects on this Windows workstation.

**What I found:**
- `python` currently resolves to `C:\Users\schep\AppData\Local\Python\pythoncore-3.14-64\python.exe` and reports `Python 3.14.0`.
- `py` is missing entirely even though the App Execution Aliases screen shows Python Install Manager entries.
- `conda.exe` is globally available from `C:\Users\schep\miniconda3\scripts\conda.exe`, and Miniconda is on the user PATH.
- `bash` resolves to `C:\Windows\System32\bash.exe`, not Git Bash.
- `wsl --status` shows the default distro is `docker-desktop`, which is not a normal interactive dev distro.
- User and machine PATH both contain duplicates and mixed Windows/system entries, which increases command-resolution drift.

**Target standard:**
- Python: standardize on Windows Python Install Manager / `py.exe` with one primary CPython install.
- Conda: keep installed only if needed later, but remove it from the default global Python resolution path.
- Windows shells: PowerShell 7 for Windows-native work.
- Unix-like shells: Git Bash for lightweight `bash` compatibility, and a real WSL distro such as Ubuntu for Linux workflows.
- WSL access: use `wsl.exe` for Linux workflows; do not leave `docker-desktop` as the default interactive distro.

## Phase 1: Capture and back up the current machine state
- Export user and machine PATH values before changing anything.
- Record current command resolution for `python`, `py`, `conda`, `bash`, `wsl`, `pwsh`, `git`, and `node`.
- Inspect PowerShell profile files and terminal profiles for any stale PATH mutation or conda auto-activation hooks.
- Save a short rollback note with the original PATH values and any aliases that get toggled.

## Phase 2: Standardize Python on Windows
- Keep the current CPython install only if it is healthy; otherwise repair or reinstall Python Install Manager so `py.exe` works again.
- Ensure one primary Python install is the default for `python` and `py`.
- Remove Miniconda directories from the global user PATH so `python` no longer competes with Conda by default.
- Keep Conda installed, but require explicit activation when needed instead of making it part of the baseline shell state.
- Validate with `where python`, `where py`, `python --version`, `py --version`, and `py -0p`.

## Phase 3: Fix shell resolution for Bash and WSL
- Install or confirm a real WSL distro such as Ubuntu.
- Change the default WSL distro from `docker-desktop` to the real dev distro.
- Keep WSL accessible via `wsl.exe` and verify interactive shell startup works.
- Add Git Bash’s actual executable directory to PATH so Windows tools that invoke `bash` resolve Git Bash instead of `System32\bash.exe`.
- Re-check `where bash`, `bash --version`, `wsl --status`, and `wsl -l -v`.

## Phase 4: Clean PATH and execution-alias conflicts
- Remove duplicate PATH entries from the user and machine scopes where safe.
- Keep `WindowsApps` only once in PATH and avoid letting broken alias stubs become the primary tool resolution path.
- Disable Python-related App Execution Aliases that conflict with the repaired Python setup if they still shadow the real executables.
- Leave non-relevant aliases alone unless they are proven to interfere.

## Phase 5: Validate end-to-end developer workflows
- Verify commands from PowerShell, Cursor integrated terminal, and VS Code integrated terminal.
- Test `python`, `py`, `pip`, `conda`, `bash`, `git`, `wsl`, and one repo-specific workflow that previously failed.
- Confirm that project tools which shell out to `bash` now work without hitting broken WSL launcher behavior.
- Confirm PowerShell starts cleanly without conda or alias noise unless explicitly requested.

## Validation checklist
- `python` and `py` both resolve and report the same intended CPython version.
- `conda` is available when explicitly invoked, but it no longer owns default Python resolution.
- `bash` resolves to Git Bash, not `System32\bash.exe`.
- `wsl` opens a real distro, not `docker-desktop`.
- Cursor and VS Code terminals inherit the cleaned PATH and shell behavior.
- No project needs custom PATH hacks to reach Python or Bash.