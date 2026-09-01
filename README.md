# homebrew-geno

Homebrew tap for [geno-tools](https://github.com/42euge/geno-tools), the skillset manager for coding agents.

## Install

```bash
brew tap 42euge/geno
brew install geno-tools
```

## What gets installed

| Command | Repo | Purpose |
|---|---|---|
| `geno-tools` | [geno-tools](https://github.com/42euge/geno-tools) | Install, update, inspect, and audit agent skillsets |

The rest of the geno ecosystem is packaged separately and is not installed by
this formula.

## Quick start

```bash
geno-tools discover
geno-tools install <skillset>
geno-tools status
```

Use `geno-tools system uninstall` before `brew uninstall geno-tools` to remove
geno-tools-managed registrations while preserving user data under `~/.geno`.
