# homebrew-geno

Homebrew tap for the [geno ecosystem](https://github.com/42euge) — agentic workspace orchestration.

## Install

```bash
brew tap 42euge/geno
brew install geno
```

## What gets installed

| Command | Repo | Purpose |
|---|---|---|
| `geno-tools` | geno-tools | Meta package manager for geno skillsets |
| `tt` | geno-tt | iTerm2 + workspace orchestration |
| `geno-vault` | geno-vault | Registry sync, web GUI, iTerm2 daemon |
| `surf` | geno-surf | Chromium agent-side tab group control |
| `pear` | geno-pear | Shared mtime-watch library |

## Quick start

```bash
# Start the daemon (keeps iTerm tabs in sync with the registry)
geno-vault serve &

# Open the workspace GUI at localhost:8787
geno-vault gui
```

Requires iTerm2 with **Settings ▸ General ▸ Magic ▸ Enable Python API** turned on.
