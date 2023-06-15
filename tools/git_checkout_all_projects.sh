#!/bin/bash

if [[ "$@" == *"-p="* ]] || [[ "$@" == *"-p "* ]]; then
     project_dir=$(echo "$@" | sed -n 's/.*-p[= ]\([^ ]*\).*/\1/p')
else
    echo "Usage: -p=绝对路径"
    exit 0
fi

if [[ "$@" == *"-b="* ]] || [[ "$@" == *"-b "* ]]; then
     branch=$(echo "$@" | sed -n 's/.*-b[= ]\([^ ]*\).*/\1/p')
else
    echo "Usage: -b=分支名"
    exit 0
fi

project_dirs=$(find "$project_dir" -maxdepth 1 -type d)

for dir in $project_dirs; do
  if [ "$dir" != "$project_dir" ]; then
    cd "$dir"
    git checkout $branch
    cd -
  fi
done
