#!/bin/bash

source <(k3s kubectl completion bash | sed -e "s/\$(kubectl/\$(k3s kubectl/g" | sed -e "s/_kubectl/_k3s_kubectl/g" | head -n -7)
source <(k3s crictl completion bash)
function __k3s_autocomplete
{
  COMPREPLY=()
  case "${COMP_WORDS[1]}" in
    "kubectl")
      if [ -n "$(which kubectl)" ]; then 
        shift
        __start_k3s_kubectl
      fi   
      ;;   
    "server")
      COMPREPLY=( $(compgen -W "$(k3s server --help | grep "^OPTIONS:$" -A100 | tail -n+2 | grep -Po "(^[ ]+\K[^ ]+|, \K[^ ]+(?=.*  ))")" -- ${COMP_WORDS[COMP_CWORD]}) )
    ;; 
    "agent")
      COMPREPLY=( $(compgen -W "$(k3s agent --help | grep "^OPTIONS:$" -A100 | tail -n+2 | grep -Po "(^[ ]+\K[^ ]+|, \K[^ ]+(?=.*  ))")" -- ${COMP_WORDS[COMP_CWORD]}) )
    ;;     
    "crictl")
      if [ -n "$(which crictl)" ]; then
        shift
        _cli_bash_autocomplete
      fi
    ;;
    "help"|"h"|"--debug"|"--help"|"--version")
      return
    ;;   
    *)     
      COMPREPLY=( $(compgen -W "server agent kubectl crictl help h --debug --help --version" -- "${COMP_WORDS[COMP_CWORD]}") )
    ;;   
  esac     
}
complete -o default -F __k3s_autocomplete k3s

