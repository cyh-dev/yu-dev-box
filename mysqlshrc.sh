#!/bin/bash

if [[ $(uname) == "Darwin" ]]; then
    # brew install mysql@5.7
	if [ -d "/usr/local/opt/mysql@5.7/bin" ]; then
		export PATH="$PATH:/usr/local/opt/mysql@5.7/bin"
		export LDFLAGS="-L/usr/local/opt/mysql-client@5.7/lib"
		export CPPFLAGS="-I/usr/local/opt/mysql-client@5.7/include"
		export PKG_CONFIG_PATH="/usr/local/opt/mysql@5.7/lib/pkgconfig"
	fi
fi
