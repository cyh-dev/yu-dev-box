#!/bin/bash

kubectl_get_pods_cmd="$( cd "$( dirname "${BASH_SOURCE[0]:-${(%):-%N}}" )" >/dev/null 2>&1 && pwd )/kubectl-get-pod-info.sh"
alias kubectl-get-pods=$kubectl_get_pods_cmd

kubectl_desc_cmd="$( cd "$( dirname "${BASH_SOURCE[0]:-${(%):-%N}}" )" >/dev/null 2>&1 && pwd )/kubectl-desc.sh"
alias kubectl-desc=$kubectl_desc_cmd

kubectl_bash_cmd="$( cd "$( dirname "${BASH_SOURCE[0]:-${(%):-%N}}" )" >/dev/null 2>&1 && pwd )/kubectl-bash.sh"
alias kubectl-bash=$kubectl_bash_cmd

kubectl_sh_cmd="$( cd "$( dirname "${BASH_SOURCE[0]:-${(%):-%N}}" )" >/dev/null 2>&1 && pwd )/kubectl-sh.sh"
alias kubectl-sh=$kubectl_sh_cmd

kubectl_exec_cmd="$( cd "$( dirname "${BASH_SOURCE[0]:-${(%):-%N}}" )" >/dev/null 2>&1 && pwd )/kubectl-exec.sh"
alias kubectl-exec=$kubectl_exec_cmd

kubectl_log_cmd="$( cd "$( dirname "${BASH_SOURCE[0]:-${(%):-%N}}" )" >/dev/null 2>&1 && pwd )/kubectl-log.sh"
alias kubectl-log=$kubectl_log_cmd

kubectl_cpr_cmd="$( cd "$( dirname "${BASH_SOURCE[0]:-${(%):-%N}}" )" >/dev/null 2>&1 && pwd )/kubectl-cpr.sh"
alias kubectl-cpr=$kubectl_cpr_cmd
kubectl_cps_cmd="$( cd "$( dirname "${BASH_SOURCE[0]:-${(%):-%N}}" )" >/dev/null 2>&1 && pwd )/kubectl-cps.sh"
alias kubectl-cps=$kubectl_cps_cmd


# k8s zsh compdef
if type compdef &>/dev/null; then
    source $( cd "$( dirname "${BASH_SOURCE[0]:-${(%):-%N}}" )" >/dev/null 2>&1 && pwd )/kubectl-compdef-zshrc.sh
fi
