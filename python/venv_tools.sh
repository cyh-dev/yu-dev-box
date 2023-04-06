#!/bin/bash

if [ ! -n "$DEFAULT_USE_PYTHON" ]; then
    echo "[WARNING] python路径$DEFAULT_USE_PYTHON 不存在, 可以设置DEFAULT_USE_PYTHON路径"
    return
fi

# pip install virtualenvwrapper
virtualenvwrapper_script="$DEFAULT_USE_PYTHON/bin/virtualenvwrapper.sh"
if [ ! -e "$virtualenvwrapper_script" ]; then
    $DEFAULT_USE_PYTHON/bin/pip install virtualenvwrapper
fi

if [[ $(uname) == "Darwin" ]]; then
    export WORKON_HOME="$HOME/.virtualenvs"
    export VIRTUALENVWRAPPER_PYTHON=$(which python3)
else
    export WORKON_HOME="/workspace/virtualenvs"
    export VIRTUALENVWRAPPER_PYTHON=$DEFAULT_USE_PYTHON/bin/python3
fi

source $virtualenvwrapper_script


# 定义一个变量来存储当前所在的虚拟环境名称和目标目录的绝对路径
CURRENT_VENV_NAME=""
TARGET_DIR_ABS_PATH=""

# 进入目录时自动激活虚拟环境
_activate_venv() {
    local makefile_path="Makefile"
    local makefile_venv_name=""
    local current_dir_abs_path=$(pwd -P)

    # 如果在目标目录或目标目录的子目录中，则不需要再次激活虚拟环境
    if [[ -n "$VIRTUAL_ENV" && "$current_dir_abs_path" == "$TARGET_DIR_ABS_PATH"* ]]; then
        return
    fi

    # 如果不在目标目录或目标目录的子目录中，则需要判断是否需要退出虚拟环境
    if [[ -n "$CURRENT_VENV_NAME" && "$current_dir_abs_path" != "$TARGET_DIR_ABS_PATH"* ]]; then
        deactivate
        CURRENT_VENV_NAME=""
    fi

    # 检查当前目录下是否存在 Makefile 文件
    if [[ -f "$makefile_path" ]]; then
        # 如果 Makefile 文件中包含 VENV_NAME 变量，则激活对应的虚拟环境
        makefile_venv_name=$(grep "^VENV_NAME" $makefile_path | cut -d "=" -f 2 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
        if [[ -n "$makefile_venv_name" ]] && workon | grep -q "^$makefile_venv_name$"; then
            workon $makefile_venv_name
            CURRENT_VENV_NAME=$makefile_venv_name
            TARGET_DIR_ABS_PATH=$current_dir_abs_path
        fi
    fi
}

# 离开目录时自动退出虚拟环境
_deactivate_venv() {
    local current_dir_abs_path=$(pwd -P)

    # 如果在目标目录或目标目录的子目录中，则不需要退出虚拟环境
    if [[ -n "$CURRENT_VENV_NAME" && "$current_dir_abs_path" == "$TARGET_DIR_ABS_PATH"* ]]; then
        return
    fi

    # 如果不在目标目录或目标目录的子目录中，则需要退出虚拟环境
    if [[ -n "$CURRENT_VENV_NAME" && "$current_dir_abs_path" != "$TARGET_DIR_ABS_PATH"* ]]; then
        deactivate
        CURRENT_VENV_NAME=""
        TARGET_DIR_ABS_PATH=""
    fi
}

# 注册目录钩子函数
# zsh
precmd_functions+=( _activate_venv )
precmd_functions+=( _deactivate_venv )
# bash
PROMPT_COMMAND="$PROMPT_COMMAND;_activate_venv"
PROMPT_COMMAND="$PROMPT_COMMAND;_deactivate_venv"
