#!/bin/zsh

ZSH_THEME="agnoster"
export ZSH="$( cd "$( dirname "${BASH_SOURCE[0]:-${(%):-%N}}" )" >/dev/null 2>&1 && pwd )/.oh-my-zsh"
export ZSH_DISABLE_COMPFIX=true
export ZSH_CACHE_DIR="$ZSH/cache"
export _Z_DATA="$ZSH_CACHE_DIR/.z"

if [ ! -d "$ZSH" ]; then
    git clone https://github.com/ohmyzsh/ohmyzsh $ZSH
fi

custom_plugins=(
    "git-open" "https://github.com/paulirish/git-open.git"
    "zsh-autosuggestions" "https://github.com/zsh-users/zsh-autosuggestions.git"
    "zsh-syntax-highlighting" "https://github.com/zsh-users/zsh-syntax-highlighting.git"
)

custom_plugin_names=()
custom_plugin_path=$ZSH/custom/plugins
for ((i=1; i<${#custom_plugins[@]}; i+=2)); do
    plugin_name=${custom_plugins[i]}
    plugin_url=${custom_plugins[i+1]}
    if [ ! -d "$custom_plugin_path/$plugin_name" ]; then
        git clone  $plugin_url $custom_plugin_path/$plugin_name
    fi
    custom_plugin_names+=($plugin_name)
done

plugins=(git extract z history-substring-search "${custom_plugin_names[@]}")

source $ZSH/oh-my-zsh.sh
