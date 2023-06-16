#!/usr/bin/python3
# -*- coding: utf-8 -*-
import argparse
import ast
import os
import time

with open(os.path.join(os.path.expanduser("~"), "bin/open_all_chrome_projects.json")) as f:
    project_url_dict = ast.literal_eval(f.read())

allow_envs = ["uat", "test", "live", "staging"]


def filter_projects(key):
    print("Index\tProject")
    index = 0
    result_projects = []
    for project in project_url_dict.keys():
        if key in project:
            index += 1
            print("{index}\t{project}".format(index=index, project=project))
            result_projects.append(project)

    return result_projects


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('-e', '--env', default="uat",
                        type=str, help='env')
    parser.add_argument('-p', '--project', required=True,
                        type=str, help='project: menu')

    args = parser.parse_args()

    if args.env not in allow_envs:
        print("允许选择的环境为:", allow_envs)
        return

    projects = filter_projects(args.project)
    if len(projects) == 0:
        print("无打开工程!", args.project)
        return

    while True:
        try:
            index = input("请选择project, index: ")
            if not index:
                return
            if 0 < int(index) <= len(projects):
                break

            print("输入index错误请重新输入!")
        except KeyboardInterrupt:
            return
        except:
            print("输入index错误请重新输入!")

    select_project = projects[int(index) - 1]
    urls = " ".join(project_url_dict[select_project][args.env])
    if not urls:
        print("工程:{0},环境:{1},未设置打开url".format(select_project, args.env))
    time.sleep(1)
    os.system('open -n -a "Google Chrome" --args --new-window ' + urls)


if __name__ == '__main__':
    main()
