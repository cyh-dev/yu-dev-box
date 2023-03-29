#!/bin/bash

if [[ $(uname) == "Darwin" ]]; then
    # brew install openjdk@8
	if [ -d "/usr/local/opt/openjdk@8/bin" ]; then
		export PATH="$PATH:/usr/local/opt/openjdk@8/bin"
		export JAVA_HOME="/Library/Java/JavaVirtualMachines/openjdk-8.jdk/Contents/Home"
	fi

	# brew 只能安装最新的gradle, java8的gradle建议直接官网下载4.4版本的
	#export GRADLE_HOME="/Users/yu/opt/gradle-4.4"
	#export PATH="$PATH:$GRADLE_HOME/bin"
fi
