# My Dotfiles (chezmoi)

This repo is managed with [chezmoi](https://www.chezmoi.io/) and contains the Windows setup for Neovim, WezTerm, and PowerShell, while retaining the existing Linux shell files.

## Install on a new Windows machine

Install chezmoi, then initialize and apply the repository:

```powershell
winget install --id twpayne.chezmoi --exact
chezmoi init --apply damirparipovic
```

During `chezmoi apply`, the Windows dependency script installs the required command-line tools and PowerTab before the configuration files are applied. A post-apply hook then restores the Neovim plugins from `lazy-lock.json`; it runs again when the lockfile changes.

## Managed Windows paths

- Neovim: `%LOCALAPPDATA%\nvim`
- WezTerm: `%USERPROFILE%\.config\wezterm`
- PowerShell: `%USERPROFILE%\Documents\PowerShell\Microsoft.PowerShell_profile.ps1`
- PowerShell helper: `%USERPROFILE%\programs\powerscripts\git-ignore.ps1`

Neovim's `init.lua` bootstraps `lazy.nvim`. The repository stores the plugin specifications and `lazy-lock.json`; plugin directories, caches, logs, Mason packages, and other runtime data are installed locally and are not versioned.

## Daily workflow

When editing the live files in their normal locations:

```powershell
chezmoi status
chezmoi diff
chezmoi re-add $HOME\AppData\Local\nvim
chezmoi re-add $HOME\.config\wezterm
chezmoi re-add $HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
```

When editing the chezmoi source state directly:

```powershell
chezmoi edit $HOME\AppData\Local\nvim\init.lua
chezmoi apply
```

Commit and push the source repository after reviewing the changes. On another machine, pull and apply them with:

```powershell
chezmoi update
```

Linux-specific shell files remain in the repository and are excluded on Windows via `.chezmoiignore`.
