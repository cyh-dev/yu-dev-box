#!/bin/zsh

if [[ $(uname) == "Darwin" ]]; then
	export HISTFILE=$HOME/.zsh_history
else
	export HISTFILE=/workspace/.zsh_history
fi

source $( cd "$( dirname "${BASH_SOURCE[0]:-${(%):-%N}}" )" >/dev/null 2>&1 && pwd )/commonshrc.sh

# oh-my-zsh
source $( cd "$( dirname "${BASH_SOURCE[0]:-${(%):-%N}}" )" >/dev/null 2>&1 && pwd )/oh-my-zsh/ohmyzshrc.sh
