#!/bin/zsh
# Load Version Control Information
autoload -Uz vcs_info

# Load colors
autoload -U colors && colors

# Enable git info via vcs_info
zstyle ':vcs_info:*' enable git

# Function to update vcs_info
precmd_vcs_info() { vcs_info }

# Run `precmd_vcs_info` before each prompt
precmd_functions+=( precmd_vcs_info )

# Enable prompt substitution
setopt prompt_subst

# Enable checking for changes in git
zstyle ':vcs_info:*' check-for-changes true

# Git status hook (checks for untracked files)
+vi-git-untracked() {
  if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
     git status --porcelain | grep -q '??'; then
    hook_com[staged]+='*' # signify new files with a star
  fi
}
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked

# Apply color to vcs_info output
zstyle ':vcs_info:git:*' formats "%F{1}%b%F{9}%u%{$reset_color%}"

# Show only the current directory or `~` in green
relativeHome="%F{2}%(4~|~|%1~)%{$reset_color%}"

# Git branch info with status
git_info="\$vcs_info_msg_0_"

# Carriage return (moves prompt to next line)
carriageReturn=$'\n'

# Command prompt `❯` in green
cmdPrompt="%F{2}❯%{$reset_color%} "

# White separator line
function separator() {
  echo "$(tput setaf 15)$(printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' '─')$(tput sgr0)"
}

function precmd() {
  separator
}

# Final prompt
PROMPT="${relativeHome} ${git_info}${carriageReturn}${cmdPrompt}"
