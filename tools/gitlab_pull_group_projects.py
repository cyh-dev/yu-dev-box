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


def get_all_projects_by_group(group_id):
    page = 1
    path = "/groups/{group_id}/projects?simple=true&per_page=50&page=".format(group_id=group_id)
    url = HOST + path
    project_infos = list()
    resp = requests.get(url + str(page), headers={'PRIVATE-TOKEN': TOKEN})
    total_page = int(resp.headers.get('X-Total-Pages', 1))
    project_infos.extend(resp.json())
    while total_page - page > 0:
        page += 1
        project_infos.extend(requests.get(url + str(page), headers={'PRIVATE-TOKEN': TOKEN}).json())

    return project_infos


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('-p', '--path', required=True, type=str, help='下载路径(绝对路径)')
    parser.add_argument('-i', '--group_ids', required=True, type=str, help='group_ids,多个id逗号隔开')
    args = parser.parse_args()

    if not os.path.exists(args.path):
        print("路径不存在!")

    group_ids = []
    try:
        group_ids = [int(group_id) for group_id in args.group_ids.split(',')]
    except:
        pass
    if not group_ids:
        print("group_ids 输入错误!")

    for group_id in group_ids:
        project_infos = get_all_projects_by_group(group_id)

        for project_info in project_infos:
            project_path = os.path.join(args.path, project_info['name'])
            if os.path.exists(project_path):
                continue

            os.system("git clone {0} {1}".format(project_info['ssh_url_to_repo'], project_path))


if __name__ == '__main__':
    main()
