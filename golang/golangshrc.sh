#!/bin/bash

if [ -z "$USER_BIN" ]; then
    echo "[ERROR] USER_BIN路径未设置! export USER_BIN="$HOME/bin""
    return
fi

export GVM="$USER_BIN/gvm"

if [[ $(uname) == "Darwin" ]]; then
    gvm_tar="gvm-mac.tar.gz"
    export GOROOT="$HOME/.g/go"
    export GOPATH="$HOME/code/go"
else
    gvm_tar="gvm-linux.tar.gz"
    export G_EXPERIMENTAL=true
    export G_HOME="/workspace/gvm"
    export GOROOT="/workspace/gvm/go"
    export GOPATH="/workspace/code/go"
fi

if [ ! -f "$GVM" ]; then
        tar -xzf "$( cd "$( dirname "${BASH_SOURCE[0]:-${(%):-%N}}" )" >/dev/null 2>&1 && pwd )/$gvm_tar" -C "$USER_BIN"
        chmod +x "$GVM"
fi

export PATH="$PATH:$GOROOT/bin"
export PATH="$PATH:$GOPATH/bin"
export G_MIRRDR=https://golang.google.cn/dl/
