#!/bin/bash

# k8s
source $( cd "$( dirname "${BASH_SOURCE[0]:-${(%):-%N}}" )" >/dev/null 2>&1 && pwd )/k8s/k8s-aliasshrc.sh

if [[ $(uname) == "Darwin" ]]; then
	# iphone
	alias iphone="open -a Simulator"
	alias ios="open -a Simulator"
fi
