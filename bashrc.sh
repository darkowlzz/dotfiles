platform=$(uname);

if [[ $platform == 'Darwin' ]]; then
  # Use a long listing format
  alias ll='ls -la'

  # Show hidden files
  alias l.='ls -d .* --color=auto'

  # System sleep
  alias goodnight='pmset sleepnow'

  export CLICOLOR=1
  export LSCOLORS=ExFxBxDxCxegedabagacad

  # vagrant-completion
  if [ -f `brew --prefix`/etc/bash_completion.d/vagrant ]; then
    source `brew --prefix`/etc/bash_completion.d/vagrant
  fi

elif [[ $platform == 'Linux' ]]; then
  # Colorize the ls output
  alias ls='ls --color=auto'

  # Use a long listing format
  alias ll='ls -la'

  # Show hidden files
  alias l.='ls -d .* --color=auto'
fi


# PS1 with git branch
PS1='\[\e[0;32m\]\u@\[\e[1;34m\]\h\[\e[0m\]\[\e[0m\]:\[\e[1;31m\]\w\[\e[0;32m\]$(__git_ps1 " (%s)")\[\e[0;39m\]\n\$ '

# Load git-completion
source ~/git-completion.bash

# Load git-prompt
source ~/.git-prompt.sh

# Indicate staged and non-staged changes
GIT_PS1_SHOWDIRTYSTATE=1

# Check Internet connection
alias pingg="ping -s 0 8.8.8.8"

# Show size of file or dir
alias sizeof="du -sh"

# Show system storage info
alias space="df -h"

# Show what's running on a given port
alias onport="lsof -i"

# tmux(Screen) aliases
alias mv+="tmux swap-window -t +1" # move window to right
alias mv-="tmux swap-window -t -1" # move window to left
