# Specify directory to install
cask_args appdir: "/Applications"

# Tap Homebrew
tap 'homebrew/bundle'
tap 'azure/azd'

# Install packages
brew 'mas'
brew 'tmux'
brew 'node'
brew 'neovim'
brew 'direnv'
brew 'git'
brew 'tree'
brew 'starship'
brew 'zsh-syntax-highlighting'
brew 'zsh-autosuggestions'
brew 'azure-cli'
brew 'azd'
brew 'yazi'

# Fonts
cask 'font-jetbrains-mono'
cask 'font-meslo-lg-nerd-font'

# Other apps
cask 'visual-studio-code'

# App Store apps
