export FZF_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"/fzf

# Setup fzf
# ---------
if [[ ! "$PATH" == *${FZF_HOME}/bin* ]]; then
  export PATH="${PATH:+${PATH}:}${FZF_HOME}/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "${FZF_HOME}/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "${FZF_HOME}/shell/key-bindings.zsh"
