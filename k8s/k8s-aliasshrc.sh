#!/bin/bash

alias kubectl-get-pods-vn-test="$( cd "$( dirname "${BASH_SOURCE[0]:-${(%):-%N}}" )" >/dev/null 2>&1 && pwd )/kubectl-get-pod-info.sh -c=vn.test"
alias kubectl-get-pods-vn-live="$( cd "$( dirname "${BASH_SOURCE[0]:-${(%):-%N}}" )" >/dev/null 2>&1 && pwd )/kubectl-get-pod-info.sh -c=vn.live"

alias kubectl-bash-vn-test="$( cd "$( dirname "${BASH_SOURCE[0]:-${(%):-%N}}" )" >/dev/null 2>&1 && pwd )/kubectl-exec.sh -c=vn.test -e=bash"
alias kubectl-bash-vn-live="$( cd "$( dirname "${BASH_SOURCE[0]:-${(%):-%N}}" )" >/dev/null 2>&1 && pwd )/kubectl-exec.sh -c=vn.live -e=bash"

alias kubectl-sh-vn-test="$( cd "$( dirname "${BASH_SOURCE[0]:-${(%):-%N}}" )" >/dev/null 2>&1 && pwd )/kubectl-exec.sh -c=vn.test -e=sh"
alias kubectl-sh-vn-live="$( cd "$( dirname "${BASH_SOURCE[0]:-${(%):-%N}}" )" >/dev/null 2>&1 && pwd )/kubectl-exec.sh -c=vn.live -e=sh"

alias kubectl-log-vn-test="$( cd "$( dirname "${BASH_SOURCE[0]:-${(%):-%N}}" )" >/dev/null 2>&1 && pwd )/kubectl-log.sh -c=vn.test"
alias kubectl-log-vn-live="$( cd "$( dirname "${BASH_SOURCE[0]:-${(%):-%N}}" )" >/dev/null 2>&1 && pwd )/kubectl-log.sh -c=vn.live"

alias kubectl-cpr-vn-test="$( cd "$( dirname "${BASH_SOURCE[0]:-${(%):-%N}}" )" >/dev/null 2>&1 && pwd )/kubectl-cp.sh -c=vn.test -ops=r"
alias kubectl-cps-vn-test="$( cd "$( dirname "${BASH_SOURCE[0]:-${(%):-%N}}" )" >/dev/null 2>&1 && pwd )/kubectl-cp.sh -c=vn.test -ops=s"
alias kubectl-cpr-vn-live="$( cd "$( dirname "${BASH_SOURCE[0]:-${(%):-%N}}" )" >/dev/null 2>&1 && pwd )/kubectl-cp.sh -c=vn.live -ops=r"
alias kubectl-cps-vn-live="$( cd "$( dirname "${BASH_SOURCE[0]:-${(%):-%N}}" )" >/dev/null 2>&1 && pwd )/kubectl-cp.sh -c=vn.live -ops=s"

alias kubectl-desc-vn-test="$( cd "$( dirname "${BASH_SOURCE[0]:-${(%):-%N}}" )" >/dev/null 2>&1 && pwd )/kubectl-desc.sh -c=vn.test"
alias kubectl-desc-vn-live="$( cd "$( dirname "${BASH_SOURCE[0]:-${(%):-%N}}" )" >/dev/null 2>&1 && pwd )/kubectl-desc.sh -c=vn.live"
