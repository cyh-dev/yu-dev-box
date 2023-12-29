#!/bin/bash

# context
if [[ "$@" == *"-c="* ]] || [[ "$@" == *"-c "* ]]; then
    context=$(echo "$@" | sed -n 's/.*-c[= ]\([^ ]*\).*/\1/p')
else
    echo "Usage: [-c=vn.test|-c vn.test]"
    exit 0
fi

# namespace
if [[ "$@" == *"-n="* ]] || [[ "$@" == *"-n "* ]]; then
    namespace=$(echo "$@" | sed -n 's/.*-n[= ]\([^ ]*\).*/\1/p')
else
    echo "Usage: [-n=qa|-n qa]"
    exit 0
fi

# pod_keyword
if [[ "$@" == *"-p="* ]] || [[ "$@" == *"-p "* ]]; then
    pod_keyword=$(echo "$@" | sed -n 's/.*-p[= ]\([^ ]*\).*/\1/p')
else
    echo "Usage: [-p=menu|-p menu]"
    exit 0
fi

# -o wide
wide_cmd=""
if [[ "$@" == *"-o="* ]] || [[ "$@" == *"-o "* ]]; then
    pods_output=$(echo "$@" | sed -n 's/.*-o[= ]\([^ ]*\).*/\1/p')
    if [ "$pods_output" == "wide" ]; then
        wide_cmd="-o=$pods_output"
    fi
fi

# -select_container=y
select_container="n"
if [[ "$@" == *"-select_container="* ]] || [[ "$@" == *"-select_container "* ]]; then
    select_container=$(echo "$@" | sed -n 's/.*-select_container[= ]\([^ ]*\).*/\1/p')
fi

cmd='kubectl --context '"$context"' -n '"$namespace"' get pods '"$wide_cmd"' | awk '\''NR==1 || /'"$pod_keyword"'/'\'''
# 将命令写到mac剪切板里
echo $cmd | pbcopy
eval "output=\$( $cmd )"

IFS=$'\n' read -rd '' -a array <<<"$output"

if [ ${#array[@]} -lt 2 ]; then
  echo "pod name no found"
  exit 0
fi

printf "%-10s %-10s %-10s\n" "ID ${array[0]}"

for (( i=1; i<${#array[@]}; i++ ))
do
  printf "%-10s %-10s %-10s\n" "$i  ${array[$i]}"
done

while true
do
    read -p "Input Pod Id :" index
    if [[ ! $index =~ ^[1-9][0-9]*$ ]]; then
        echo "Id 输入错误，请重新输入！"
    elif ((index <= 0 || index > ${#array[@]})); then
        echo "Id 输入错误，请重新输入！"
    else
        break
    fi
done

pod_name=${array[$index]%% *}

cmd="kubectl --context $context -n $namespace get pods $pod_name -o jsonpath='{range .spec.containers[*]}{.name}{\" \"}{.image}{\" \"}{range .ports[*]}{.containerPort}{\",\"}{end}{\"\n\"}'"
# 将命令写到mac剪切板里
echo $cmd | pbcopy
eval "container_output=\$( $cmd )"
IFS=$'\n' read -rd '' -a array <<<"$container_output"
container_index=1
if [ "$select_container" == "y" ];then
  read -p "whether to select container(y or n):" is_select_container
fi
if [ "$is_select_container" == "y" ];then
    format="%-3s %-40s %-80s %-20s\n"
    printf "$format" "Id" "Name" "Image" "Ports"
    id=1
    for line in "${array[@]}"; do
        name=$(echo "$line" | awk '{print $1}')
        image=$(echo "$line" | awk '{print $2}')
        ports=$(echo "$line" | awk '{print $3}')
        printf "$format" "$id" "$name" "$image" "$ports"
        id=$((id+1))
    done
    
    while true
    do
        read -p "Input Container Id :" container_index
        if [[ ! $container_index =~ ^[1-9][0-9]*$ ]]; then
            echo "Id 输入错误，请重新输入！"
        elif ((container_index <= 0 || container_index > ${#array[@]})); then
            echo "Id 输入错误，请重新输入！"
        else
            break
        fi
    done
fi
container_name=${array[$((container_index-1))]%% *}

echo "selected pod name: $pod_name, container_name: $container_name"

