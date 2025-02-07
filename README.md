# Dotfiles

![logo](https://dotfiles.github.io/images/dotfiles-logo.png)

This repo contains my dot file(s).

Using Stow

## Install Homebrew: macOS package manager

To install Homebrew, open iTerm and run the command:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

After installing, add the Homebrew to the PATH:

```bash
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

## Install apps from Homebrew bundle

```bash
brew bundle --file=brewfile.sh
```

## Install devbox

```bash
curl -fsSL https://get.jetify.com/devbox | bash
```

## Install g (Go Version Manager)

```bash
# It is recommended to clear the `GOROOT`, `GOBIN`, and other environment variables before installation.
$ curl -sSL https://raw.githubusercontent.com/voidint/g/master/install.sh | bash
$ cat << 'EOF' >> ~/.zshrc
# Check if the alias 'g' exists before trying to unalias it
if [[ -n $(alias g 2>/dev/null) ]]; then
    unalias g
fi
EOF 
$ source "$HOME/.g/env"
```
