#!/bin/bash

source $( cd "$( dirname "${BASH_SOURCE[0]:-${(%):-%N}}" )" >/dev/null 2>&1 && pwd )/kubectl-get-pod-info.sh

cmd="kubectl --context $context -n $namespce describe pod $pod_name"

# 将命令写到mac剪切板里
echo $cmd | pbcopy

eval $cmd

