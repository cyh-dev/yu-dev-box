#!/usr/bin/python3
# -*- coding: utf-8 -*-

import argparse
import os
import time

import requests

URL_FMT = os.getenv("JENKINS_URL_FMT")
if not URL_FMT:
    print("请设置环境变量JENKINS_URL_FMT")
    exit(1)

USER = os.getenv("JENKINS_USER")
TOKEN = os.getenv("JENKINS_TOKEN")
if not USER or not TOKEN:
    print("请设置环境变量JENKINS_USER和JENKINS_TOKEN")
    exit(1)

global_pipelines = os.getenv("JENKINS_PIPELINES")
if not global_pipelines:
    print("请设置环境变量JENKINS_PIPELINES(多个pipeline逗号分隔)")
    exit(1)
global_pipelines = global_pipelines.split(",")

allow_envs = ["qa", "test"]


def filter_pipelines(key):
    print("Index\tPipeline")
    index = 0
    result_pipelines = []
    for pipeline in global_pipelines:
        if key in pipeline:
            index += 1
            print("{index}\t{pipeline}".format(index=index, pipeline=pipeline))
            result_pipelines.append(pipeline)

    return result_pipelines


def start_job(env, pipeline, branch, cache=True):
    url = URL_FMT.format(env=env, pipeline=pipeline) + "/buildWithParameters"
    data = {
        "BRANCH": branch
    }
    if cache is False:
        data["BUILD_NO_CACHE"] = True
    resp = requests.post(url, data=data, auth=(USER, TOKEN))

    if resp.content:
        print(resp.content)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('-e', '--env', default="qa",
                        type=str, help='env: qa or test')
    parser.add_argument('-p', '--pipeline', required=True,
                        type=str, help='pipeline: menu')
    parser.add_argument('-b', '--branch', default="qa_refactor",
                        type=str, help='branch: qa_refactor')
    parser.add_argument('-ncache', '--no_cache', default=False,
                        type=bool, help='env: true or false')
    args = parser.parse_args()

    if args.env not in allow_envs:
        print("允许发布的环境为:", allow_envs)
        return

    pipelines = filter_pipelines(args.pipeline)
    if len(pipelines) == 0:
        print("无流水线!", args.pipeline)
        return

    while True:
        try:
            indexes = input("请选择pipeline(支持选择多个,例如1,2,3), index: ")
            if not indexes:
                return
            ids = []
            for index in indexes.strip().split(','):
                if 0 < int(index) <= len(pipelines):
                    ids.append(int(index))

            if len(ids) > 0:
                break

            print("输入index错误请重新输入!")
        except KeyboardInterrupt:
            return
        except:
            print("输入index错误请重新输入!")
    ids = list(set(ids))
    for _id in ids:
        select_pipeline = pipelines[_id - 1]
        web_url = URL_FMT.format(env=args.env, pipeline=select_pipeline)
        print("发布env: %s, branch: %s, pipeline: %s" %
              (args.env, args.branch, select_pipeline))
        print(web_url)
        time.sleep(1)
        os.system("open %s" % web_url)
        # url写入剪切板
        try:
            import pyperclip
            pyperclip.copy(web_url)
        except:
            pass
        start_job(env=args.env, pipeline=select_pipeline,
                  branch=args.branch, cache=not args.no_cache)


if __name__ == '__main__':
    main()
