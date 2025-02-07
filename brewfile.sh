# Specify directory to install
cask_args appdir: "/Applications"

# Tap Homebrew
tap 'homebrew/bundle'
tap 'azure/azd'

# Install packages
brew 'mas'
brew 'tmux'
brew 'direnv'
brew 'git'
brew 'tree'
brew 'starship'
brew 'zsh-syntax-highlighting'
brew 'zsh-autosuggestions'
brew 'azure-cli'
brew 'azd'

# Fonts
cask 'font-jetbrains-mono'
cask 'font-meslo-lg-nerd-font'

# Other apps
cask 'visual-studio-code'

# App Store apps
