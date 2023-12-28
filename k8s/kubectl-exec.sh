#!/bin/bash

# exec
if [[ "$@" == *"-e="* ]] || [[ "$@" == *"-e "* ]]; then
    exec=$(echo "$@" | sed -n 's/.*-e[= ]\([^ ]*\).*/\1/p')
else
    echo "Usage: [-e=bash|-e bash]"
    exit 0
fi

source $( cd "$( dirname "${BASH_SOURCE[0]:-${(%):-%N}}" )" >/dev/null 2>&1 && pwd )/kubectl-get-pod-info.sh


cmd="kubectl --context $context -n $namespace exec -it $pod_name  -c $container_name -- $exec"
# 将命令写到mac剪切板里
echo $cmd | pbcopy

eval $cmd





