export PATH=/opt/homebrew/bin:$PATH
export PATH="/opt/homebrew/opt/python@3.11/bin:$PATH"
export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"
export CPPFLAGS="-I/opt/homebrew/opt/openjdk@17/include"
export PYTHONWARNINGS="ignore"


eval "$(starship init zsh)"

source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
[ -s "${HOME}/.g/env" ] && \. "${HOME}/.g/env"  # g shell setup

autoload -U compinit && compinit

# history setup
HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

# completion using arrow keys (based on history)
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

### FUNCTIONS
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# NOTE: FZF
# Set up fzf key bindings and fuzzy completion
eval "$(fzf --zsh)"

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git "
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

export FZF_DEFAULT_OPTS="--height 50% --layout=default --border --color=hl:#2dd4bf"

# Setup fzf previews
export FZF_CTRL_T_OPTS="--preview 'bat --color=always -n --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --icons=always --tree --color=always {} | head -200'"

# fzf preview for tmux
export FZF_TMUX_OPTS=" -p90%,70% "

# ---- Fuzzy Find ----
eval "$(fzf --zsh)"

# ---- Zoxide (better cd) ----
eval "$(zoxide init zsh)"
alias cd="z"

# ---- Direnv ----
eval "$(direnv hook zsh)"

## ALIASES
alias ls="eza --icons=always"
alias compgen="bash -c 'compgen -c'"
alias fman="compgen -c | fzf | xargs man"
alias nzo="~/.config/scripts/zoxide_openfiles_nvim.sh"
alias nlof="~/.config/scripts/fzf_listoldfiles.sh"
alias bathelp='bat --plain --language=help'
alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'
alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'

alias gitsha='git rev-parse --short HEAD'
alias tf='terraform'
# Docker
alias dpull='docker pull --platform linux/amd64 $@'
alias dpst='watch -n 3 "docker ps"'
alias dps='docker ps -a'
alias dclean='docker rm -v $(docker ps -a -q -f status=exited)'
alias dpurge='docker system prune --volumes -a -f'
alias dprune='docker buildx prune -f'
alias rmc='docker ps -q -a | xargs docker rm -f'
alias rmi='docker images -q | xargs docker rmi -f'
alias d='docker $@'

# Kubernetes
alias k="kubectl"
#alias kn="kubectl config set-context --current --namespace "
alias kn="kubens "
alias ktx="kubectx"
alias kns="k config view --minify |grep namespace:"
alias kd="k describe "
alias krm="k delete "
alias kls="k get "
alias kgp="k get pods"
alias kapply="k apply -f "
alias kdelete="k delete -f "
alias kforward="k port-forward "
alias kevicted="kubectl get pods -all-namespaces | grep Evicted | awk '{print $1}' | xargs kubectl delete pod"
alias krestart="kubectl rollout restart deployment"
alias kimages="kubectl get pods --all-namespaces -o jsonpath='{.items[*].spec.containers[*].image}' |tr -s '[[:space:]]' '\n' |sort |uniq -c"
alias kfeaturegates="kubectl get --raw /metrics | grep kubernetes_feature_enabled"

# Misc
alias vpnroute="sudo route add -net 172.20.0.0/22 192.168.1.1"