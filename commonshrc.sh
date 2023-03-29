#!/bin/bash

if [ -z "$YU_DEV_BOX" ]; then
    echo "[ERROR] YU_DEV_BOX路径未设置! export YU_DEV_BOX="仓库目录路径""
    return
fi

# user bin
if [[ $(uname) == "Darwin" ]]; then
    export USER_BIN="${HOME}/bin"
else
    export USER_BIN="/workspace/bin"
fi

if [ ! -d "$USER_BIN" ]; then
  mkdir -p "$USER_BIN"
fi
export PATH="$PATH:$USER_BIN"

# shell cmd
export HISTSIZE=50000
export SAVEHIST=1000000000

# character
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# history
export HIST_STAMPS="yyyy-mm-dd"

# brew
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_INSTALL_CLEANUP=1

# golang
source $( cd "$( dirname "${BASH_SOURCE[0]:-${(%):-%N}}" )" >/dev/null 2>&1 && pwd )/golang/golangshrc.sh

# python
source $( cd "$( dirname "${BASH_SOURCE[0]:-${(%):-%N}}" )" >/dev/null 2>&1 && pwd )/python/pythonshrc.sh

# mysql
source $( cd "$( dirname "${BASH_SOURCE[0]:-${(%):-%N}}" )" >/dev/null 2>&1 && pwd )/mysqlshrc.sh

# redis
source $( cd "$( dirname "${BASH_SOURCE[0]:-${(%):-%N}}" )" >/dev/null 2>&1 && pwd )/redisshrc.sh

# java
source $( cd "$( dirname "${BASH_SOURCE[0]:-${(%):-%N}}" )" >/dev/null 2>&1 && pwd )/javashrc.sh

# openssl
source $( cd "$( dirname "${BASH_SOURCE[0]:-${(%):-%N}}" )" >/dev/null 2>&1 && pwd )/opensslshrc.sh

# android
source $( cd "$( dirname "${BASH_SOURCE[0]:-${(%):-%N}}" )" >/dev/null 2>&1 && pwd )/androidshrc.sh

# alias
source $( cd "$( dirname "${BASH_SOURCE[0]:-${(%):-%N}}" )" >/dev/null 2>&1 && pwd )/aliasshrc.sh
