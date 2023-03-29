# 获取当前脚本文件，通用sh，bash，zsh，source执行
DIR="$( cd "$( dirname "${BASH_SOURCE[0]:-${(%):-%N}}" )" >/dev/null 2>&1 && pwd )"
echo "当前文件所在目录为：$DIR"

# 判断当前系统
if [[ $(uname) == "Darwin" ]]; then
    echo "This is macOS"
else
    echo "This is Linux"
fi

