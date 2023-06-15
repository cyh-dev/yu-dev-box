#!/usr/bin/python3
# -*- coding: utf-8 -*-

import argparse
import os
from jira import JIRA

HOST = os.getenv("JIRA_HOST")
if not HOST:
    print("请设置环境变量JIRA_HOST")
    exit(1)

TOKEN = os.getenv("JIRA_TOKEN")

if not TOKEN:
    print("请设置环境变量JIRA_TOKEN")
    exit(1)

jira = JIRA(HOST, token_auth=TOKEN)


def get_cur_user_subtasks(statuses=None):
    if not statuses:
        statuses = ("Doing", "TO DO")
    jql = """assignee=currentUser() AND status in {statuses} \
                                    AND issuetype in subtaskIssueTypes() \
                                    ORDER BY due DESC""".format(statuses=statuses)

    subtasks = jira.search_issues(jql)

    return subtasks


def print_tasks(tasks, task_type="subtask"):
    tab_format = "{:<8}{:<15}{:<15}{:<15}{:<15}{:<20}"
    print(tab_format.format("Index", "TaskType", "TaskId", "Due", "TaskStatus", "TaskName"))
    index = 0
    for task in tasks:
        index += 1
        duedate = task.fields.duedate if hasattr(task.fields, "duedate") else ""
        print(tab_format.format(index,
                                task_type,
                                task.key,
                                duedate,
                                task.fields.status.name,
                                task.fields.summary,
                                ))


def print_transitions(transitions):
    tab_format = "{:<10}{:<20}"
    print(tab_format.format("Index", "Status"))
    index = 0
    for transition in transitions:
        index += 1
        print(tab_format.format(index,
                                transition['name'],
                                ))


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('-ss', '--statuses', default=("Doing", "TO DO"),
                        type=tuple, help='subtask statuses: ("Doing", "TO DO")')

    args = parser.parse_args()

    subtasks = get_cur_user_subtasks(statuses=args.statuses)

    print_tasks(subtasks)

    while True:
        try:
            index = input("请选择subtask index:")
            if not index:
                return
            if 0 < int(index) <= len(subtasks):
                break
            print("输入index错误请重新输入!")
        except KeyboardInterrupt:
            return
        except:
            print("输入index错误请重新输入!")

    select_subtask = subtasks[int(index) - 1]

    transitions = jira.transitions(select_subtask)

    print_transitions(transitions)

    while True:
        try:
            index = input("请选择subtask状态 index:")
            if not index:
                return
            if 0 < int(index) <= len(transitions):
                break
            print("输入index错误请重新输入!")
        except KeyboardInterrupt:
            return
        except:
            print("输入index错误请重新输入!")

    select_transition = transitions[int(index) - 1]

    jira.transition_issue(select_subtask, select_transition['id'])

    print('设置subtask:{0}, {1}状态成功!'.format(select_subtask, select_transition['name']))
    print('web_url:%sbrowse/%s' % (HOST, select_subtask))

    print_tasks([select_subtask.fields.parent], task_type="task")

    if input("是否扭转对应Task状态(y/n):") != "y":
        return

    transitions = jira.transitions(select_subtask.fields.parent)

    print_transitions(transitions)

    while True:
        try:
            index = input("请选择task状态 index:")
            if not index:
                return
            if 0 < int(index) <= len(transitions):
                break
            print("输入index错误请重新输入!")
        except KeyboardInterrupt:
            return
        except:
            print("输入index错误请重新输入!")

    select_transition = transitions[int(index) - 1]

    jira.transition_issue(select_subtask.fields.parent, select_transition['id'])

    print('设置task:{0}, {1}状态成功!'.format(select_subtask.fields.parent, select_transition['name']))
    print('web_url:%sbrowse/%s' % (HOST, select_subtask.fields.parent))


if __name__ == '__main__':
    main()
