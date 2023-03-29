#!/bin/bash


if [[ $(uname) == "Darwin" ]]; then
    system_python_path="$HOME/Library/Python"
else
    system_python_path="/opt/python"
fi

if [ -d "$system_python_path" ]; then
    latest_version=$(ls -1 $system_python_path | sort -V | tail -1)
    if [ -n "$latest_version" ]; then
        export LATEST_PYTHON=$system_python_path/$latest_version
    fi
fi

export DEFAULT_USE_PYTHON=${CUSTOM_USE_PYTHON:-$LATEST_PYTHON}

if [ -n "$DEFAULT_USE_PYTHON" ]; then
    export PATH="$PATH:$DEFAULT_USE_PYTHON/bin"
    source $( cd "$( dirname "${BASH_SOURCE[0]:-${(%):-%N}}" )" >/dev/null 2>&1 && pwd )/venv_tools.sh

else
    echo "[WARNING] python系统路径$system_python_path 不存在, 可以设置自定义CUSTOM_USE_PYTHON路径"
fi
