#!/bin/bash


source $( cd "$( dirname "${BASH_SOURCE[0]:-${(%):-%N}}" )" >/dev/null 2>&1 && pwd )/kubectl-get-pod-info.sh

read -p "source file path:" source_path

read -p "target file path:" target_path

cmd="kubectl --context $context cp -n $namespace -c $container_name $pod_name:$source_path $target_path"

# 将命令写到mac剪切板里
echo $cmd | pbcopy

eval $cmd

