# dotfiles

macOS setup managed with **Nix** (nix-darwin + home-manager), **Homebrew**, and **mise**.

| Layer | Manages | Source |
|---|---|---|
| Nix | CLI packages, most dotfiles, GUI casks | `flake.nix`, `nix/` |
| Homebrew | Formulae not in nixpkgs | `nix/darwin.nix`, `mise.toml` |
| mise | Runtimes, npm tools, some dotfiles | `mise.toml` |
| APM | Agent Skills | `apm.yml` |

## Setup

```sh
brew install mise ghq
ghq get git@github.com:H-ymt/dotfiles.git
cd "$(ghq root)/github.com/H-ymt/dotfiles"

# Install Nix via Determinate Systems installer:
# https://install.determinate.systems/determinate-pkg/stable/Universal

sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake .#mba
mise trust
mise bootstrap
```

## Update

```sh
sudo darwin-rebuild switch --flake .#mba   # apply Nix changes
nix flake update                           # bump inputs (revert flake.lock to roll back)
mise bootstrap                             # apply mise changes
apm install --update --target claude       # update Agent Skills
```

## Manual steps

```sh
herdr plugin install smarzban/herdr-file-viewer --yes
herdr plugin install edmundmiller/herdr-plugin-hunk --yes
herdr integration install claude
```

See [CLAUDE.md](./CLAUDE.md) for detailed rules.
