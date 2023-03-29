#!/bin/bash

if [[ $(uname) == "Darwin" ]]; then
    # brew install redis@4.0
	if [ -d "/usr/local/opt/redis@4.0/bin" ]; then
		export PATH="$PATH:/usr/local/opt/redis@4.0/bin"
	fi
fi
