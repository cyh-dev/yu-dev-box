#!/bin/bash

# ops
if [[ "$@" == *"-ops="* ]] || [[ "$@" == *"-ops "* ]]; then
    ops=$(echo "$@" | sed -n 's/.*-ops[= ]\([^ ]*\).*/\1/p')
    if [ $ops != "s" ] && [ $ops != "r" ]; then
    echo "Usage: [-ops=s or r|-ops s or r]"
    exit 0
    fi
else
    echo "Usage: [-ops=s or r|-ops s or r]"
    exit 0
fi

source $( cd "$( dirname "${BASH_SOURCE[0]:-${(%):-%N}}" )" >/dev/null 2>&1 && pwd )/kubectl-get-pod-info.sh


read -p "source file path:" source_path

read -p "target file path:" target_path

if [ $ops == "s" ]; then
  cmd="kubectl --context $context cp -n $namespce -c $container_name $source_path $pod_name:$target_path"
elif [ $ops == "r" ]; then
  cmd="kubectl --context $context cp -n $namespce -c $container_name $pod_name:$source_path $target_path"
fi

# 将命令写到mac剪切板里
echo $cmd | pbcopy

eval $cmd

