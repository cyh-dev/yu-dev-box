#!/bin/zsh

if [[ $(uname) == "Darwin" ]]; then
	export HISTFILE=$HOME/.bash_history
else
	export HISTFILE=/workspace/.bash_history
fi

source $( cd "$( dirname "${BASH_SOURCE[0]:-${(%):-%N}}" )" >/dev/null 2>&1 && pwd )/commonshrc.sh
