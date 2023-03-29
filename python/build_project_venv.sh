#!/bin/bash

# 设置虚拟环境的名称和 Python 版本
# VENV_NAME
if [[ "$@" == *"-venv_name="* ]] || [[ "$@" == *"-venv_name "* ]]; then
    VENV_NAME=$(echo "$@" | sed -n 's/.*-venv_name[= ]\([^ ]*\).*/\1/p')
else
    echo "Usage: [-venv_name=py27|-venv_name py27]"
    exit 0
fi

# PYTHON_VERSION
if [[ "$@" == *"-python="* ]] || [[ "$@" == *"-python "* ]]; then
    PYTHON_VERSION=$(echo "$@" | sed -n 's/.*-python[= ]\([^ ]*\).*/\1/p')
else
    echo "Usage: [-python=python2.7|-python python2.7]"
    exit 0
fi

# 定义 requirements 文件的位置
# REQUIREMENTS
# Usage: [-requirement=requirements.txt|-requirement requirements.txt]
if [[ "$@" == *"-requirement="* ]] || [[ "$@" == *"-requirement "* ]]; then
    REQUIREMENTS=$(echo "$@" | sed -n 's/.*-requirement[= ]\([^ ]*\).*/\1/p')
fi

# 如果用户没有指定 Python 版本，则使用默认版本
if [ -z "${python+x}" ]; then
    PYTHON=$PYTHON_VERSION
else
    PYTHON="python"
fi

# 检查 virtualenv 和 virtualenvwrapper 是否已安装
if ! command -v virtualenv &> /dev/null; then
    echo "virtualenv 未安装, 请先使用 pip install virtualenv 安装."
    exit 1
fi
if ! command -v virtualenvwrapper.sh &> /dev/null; then
    echo "virtualenvwrapper 未安装, 请先使用 pip install virtualenvwrapper 安装."
    exit 1
fi

# 加载 virtualenvwrapper.sh 文件
source $(which virtualenvwrapper.sh)

# ops
if [[ "$@" == *"-ops="* ]] || [[ "$@" == *"-ops "* ]]; then
    ops=$(echo "$@" | sed -n 's/.*-ops[= ]\([^ ]*\).*/\1/p')
    if [ $ops != "create" ] && [ $ops != "remove" ] && [ $ops != "enter" ]; then
    echo "Usage: [-ops=create or remove or enter |-ops create or remove or enter]"
    exit 0
    fi
else
    echo "Usage: [-ops=create or remove or enter |-ops create or remove or enter]"
    exit 0
fi

if [ $ops == "create" ]; then
    # 检查是否已创建了名为 $(VENV_NAME) 的虚拟环境
    if ! workon $VENV_NAME >/dev/null 2>&1; then
        echo "正在创建虚拟环境 $VENV_NAME ..."
        mkvirtualenv --python=$PYTHON $VENV_NAME > /dev/null 2>&1 || { echo >&2 "无法创建虚拟环境 $VENV_NAME"; exit 1; }
    else
        echo "已存在虚拟环境 $VENV_NAME,正在更新依赖包 ..."
    fi
    
    if [ -n "$REQUIREMENTS" ]; then
        # 激活虚拟环境并安装依赖包
        if workon $VENV_NAME && pip install -r $REQUIREMENTS; then
            echo "虚拟环境 $VENV_NAME 创建并更新成功!"
        else
            echo >&2 "安装依赖包失败，请检查 $REQUIREMENTS 文件."
            exit 1
        fi
    fi

elif [ $ops == "remove" ]; then
    # 删除虚拟环境
    echo "正在删除虚拟环境 $VENV_NAME ..."
    if rmvirtualenv $VENV_NAME; then
        echo "虚拟环境 $VENV_NAME 已删除。"
    else
        echo >&2 "无法删除虚拟环境 $VENV_NAME。"
        exit 1
    fi

elif [ $ops == "enter" ]; then
  echo "进入虚拟环境 $VENV_NAME ..."
  workon $VENV_NAME

fi
