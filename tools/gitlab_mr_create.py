#!/usr/bin/python3
# -*- coding: utf-8 -*-

import argparse
import os
import requests

HOST = os.getenv("GITLAB_HOST")
if not HOST:
    print("请设置环境变量GITLAB_HOST")
    exit(1)

TOKEN = os.getenv("GITLAB_TOKEN")
if not TOKEN:
    print("请设置环境变量GITLAB_TOKEN")
    exit(1)

PROJECTS = os.getenv("GITLAB_PROJECTS")
if not PROJECTS:
    print("请设置环境变量GITLAB_PROJECTS:{project_name1}|{project_id1},{project_name2}|{project_id2}")
    exit(1)

PROJECT_INFOS = []
for project in PROJECTS.split(","):
    PROJECT_INFOS.append(
        {
            "name": project.split("|")[0],
            "project_id": project.split("|")[1],
        }
    )


def print_projects():
    print('{:<10}{:<30}{:<20}'.format("Index", "Name", "ProjectId"))
    index = 0
    for project_info in PROJECT_INFOS:
        index += 1
        print("{:<10}{:<30}{:<20}".format(
            index, project_info['name'], project_info['project_id']))


def search_branchs(project_id, search_key=""):
    path = "/projects/{project_id}/repository/branches?search={search_key}". \
        format(project_id=project_id, search_key=search_key)

    url = HOST + path

    branch_infos = requests.get(url, headers={'PRIVATE-TOKEN': TOKEN}).json()

    return branch_infos


def print_branch_infos(branch_infos):
    index = 0
    print('Index\tBranchName')
    for branch_info in branch_infos:
        index += 1
        print("{index}\t{name}".format(index=index, name=branch_info["name"]))


def create_mr(project_id, title, source_branch, target_branch):
    path = "/projects/{project_id}/merge_requests".format(
        project_id=project_id)

    url = HOST + path
    data = {
        'title': title,
        'source_branch': source_branch,
        'target_branch': target_branch,
    }

    mr_info = requests.post(url, data=data, headers={
        'PRIVATE-TOKEN': TOKEN}).json()

    return mr_info


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('-d', '--draft', default=False,
                        type=bool, help='draft: true or false')
    args = parser.parse_args()

    print_projects()
    while True:
        try:
            index = input("请选择工程, index: ")
            if 0 < int(index) <= len(PROJECT_INFOS):
                break
            print("输入index错误请重新输入!")
        except KeyboardInterrupt:
            return
        except:
            print("输入index错误请重新输入!")

    select_project = PROJECT_INFOS[int(index) - 1]

    source_branch = ""
    while True:
        branch_key = input("请输入分支名(支持模糊搜索), branch_key: ")
        branch_infos = search_branchs(select_project['project_id'], branch_key)
        if len(branch_infos) == 0:
            print('该jira单号无对应分支,请重新输入')
            continue

        if len(branch_infos) == 1:
            source_branch = branch_infos[0]['name']
        else:
            print_branch_infos(branch_infos=branch_infos)
            while True:
                try:
                    index = input("请选择源分支, index: ")
                    if 0 < int(index) <= len(branch_infos):
                        break
                    print("输入index错误请重新输入!")
                except KeyboardInterrupt:
                    return
                except:
                    print("输入index错误请重新输入!")
            source_branch = branch_infos[int(index) - 1]['name']
        break

    target_branch = input("请输入目标分支名(默认为master), target_branch: ")
    if not target_branch:
        target_branch = "master"
    else:
        while True:
            branch_infos = search_branchs(
                select_project['project_id'], target_branch)
            if len(branch_infos) == 0:
                print('目标分支不存在,请重新输入')
                continue

            if len(branch_infos) == 1:
                target_branch = branch_infos[0]["name"]
            else:
                print_branch_infos(branch_infos)
                while True:
                    try:
                        index = input("请选择目标分支, index: ")
                        if 0 < int(index) <= len(branch_infos):
                            break
                        print("输入index错误请重新输入!")
                    except KeyboardInterrupt:
                        return
                    except:
                        print("输入index错误请重新输入!")
                target_branch = branch_infos[int(index) - 1]['name']
            break

    msg = ""
    jira_id = ""
    default_title = "<{target_branch}>{source_branch}".format(target_branch=target_branch, source_branch=source_branch)
    if len(source_branch.split('/')) == 3:
        msg = source_branch.split('/')[2].replace('-', " ")
        jira_id = source_branch.split('/')[1]

    if jira_id:
        default_title = "<{target_branch}>[{jira_id}]{msg}".format(target_branch=target_branch,
                                                                   jira_id=jira_id,
                                                                   msg=msg)
    if args.draft:
        default_title = "Draft: " + default_title
    title = input('请输入mr title(默认为: "{0}", title: '.format(default_title))
    if not title:
        title = default_title

    mr_info = create_mr(select_project['project_id'], title,
                        source_branch=source_branch, target_branch=target_branch)

    mr_output = "message: {message}\nmerge_error: {merge_error}\nweb_url: {web_url}".format(
        message=mr_info.get('message'),
        merge_error=mr_info.get("merge_error"),
        web_url=mr_info.get("web_url"))

    print(mr_output)

    # url写入剪切板
    try:
        import pyperclip
        if mr_info.get("web_url"):
            os.system("open %s" % mr_info.get("web_url"))
            pyperclip.copy(mr_info.get("web_url"))
    except ImportError:
        pass


if __name__ == '__main__':
    main()
