#compdef

_kubectl_completion() {
  local -a options
  local -a descriptions
  local state

  _arguments -C \
    '(-c)-c[(kubectl --context)]: :->c_opts' \
    '(-n)-n[(kubectl --namespace)]: :->n_opts' \
    '(-p)-p[(kubectl --pod_keyword)]: :->p_opts' \
    '(-select_container)-select_container[whether to select container]: :->select_container_opts' \
    '(-o)-o[(kubectl --wide)]: :->o_opts' \
    '(-e)-e[(kubectl --exec cmd)]: :->e_opts' \
    '*:: :->default'

  case $state in
    (c_opts)
      options=('vn.test' 'vn.live')
      _describe -t c_options 'c options' options && ret=0
      ;;
    (n_opts)
      options=('qa' 'test' 'live' 'staging')
      _describe -t n_options 'n options' options && ret=0
      ;;
    (p_opts)
      options=('menu' 'nowcrm' 'merchant-api')
      _describe -t p_options 'p options' options && ret=0
      ;;
    (o_opts)
      options=('wide')
      _describe -t o_options 'o options' options && ret=0
      ;;
    (e_opts)
      options=('bash' 'sh' 'ls -l')
      _describe -t e_options 'e options' options && ret=0
      ;;
    (select_container_opts)
      options=('y')
      _describe -t select_container_options 'select_container options' options && ret=0
      ;;
  esac

  return $ret
}


compdef _kubectl_completion $kubectl_get_pods_cmd
compdef _kubectl_completion $kubectl_desc_cmd
compdef _kubectl_completion $kubectl_bash_cmd
compdef _kubectl_completion $kubectl_sh_cmd
compdef _kubectl_completion $kubectl_exec_cmd
compdef _kubectl_completion $kubectl_log_cmd
compdef _kubectl_completion $kubectl_cps_cmd
compdef _kubectl_completion $kubectl_cpr_cmd
