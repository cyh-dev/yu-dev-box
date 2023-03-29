#!/bin/bash

if [[ $(uname) == "Darwin" ]]; then
    # brew install openssl@3
	if [ -d "/usr/local/opt/openssl@3/bin" ]; then
		export PATH="$PATH:/usr/local/opt/openssl@3/bin"
		export PKG_CONFIG_PATH="/usr/local/opt/openssl@3/lib/pkgconfig"
		export LDFLAGS="-L/usr/local/opt/openssl@3/lib"
		export CPPFLAGS="-I/usr/local/opt/openssl@3/include"
	fi
fi

