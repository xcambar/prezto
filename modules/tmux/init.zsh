#
# Defines tmux aliases and provides for auto launching it at start-up.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#   Colin Hebert <hebert.colin@gmail.com>
#   Georges Discry <georges@discry.be>
#   Xavier Cambar <xcambar@gmail.com>
#

# Return if requirements are not found.
if (( ! $+commands[tmux] )); then
  return 1
fi

#
# Auto Start
#

if [[ -z "$TMUX" && -z "$EMACS" && -z "$VIM" ]] && ( \
  ( [[ -n "$SSH_TTY" ]] && zstyle -t ':prezto:module:tmux:auto-start' remote ) ||
  ( [[ -z "$SSH_TTY" ]] && zstyle -t ':prezto:module:tmux:auto-start' local ) \
); then
  tmux_session='#Prezto'

  if ! tmux has-session -t "$tmux_session" 2> /dev/null; then
    # Ensure that tmux server is started.
    tmux start-server

    # Disable the destruction of unattached sessions globally.
    tmux set-option -g destroy-unattached off &> /dev/null

    # Create a new session.
    tmux new-session -d -s "$tmux_session"

    # Disable the destruction of the new, unattached session.
    tmux set-option -t "$tmux_session" destroy-unattached off &> /dev/null

    # Enable the destruction of unattached sessions globally to prevent
    # an abundance of open, detached sessions.
    if zstyle -t ':prezto:module:tmux' destroy-unattached ; then
      tmux set-option -g destroy-unattached on &> /dev/null
    fi
  fi

  # Attach to the 'prezto' session or to the last session used.
  exec tmux attach-session
fi

#
# Aliases
#

alias tmuxa='tmux attach-session'
alias tmuxl='tmux list-sessions'
