# -*- coding: utf-8 -*-
import argparse
import fnmatch
import os
import re
import subprocess

import requests
from pylint.lint import Run

scan_files = []

scan_dirs = []

ignore_patterns = []


def is_ignore_file(file_path):
    global ignore_patterns
    for ignore_pattern in ignore_patterns:
        if re.match(ignore_pattern, file_path):
            return True

    return False


def expand_scan_dirs():
    py_files = list()
    for scan_dir in scan_dirs:
        for root, _, filenames in os.walk(scan_dir):
            for filename in fnmatch.filter(filenames, '*.py'):
                file_path = os.path.join(root, filename)
                py_files.append(file_path)

    return py_files


def get_all_scan_files():
    global scan_files, scan_dirs
    all_scan_files = list()
    dir_files = expand_scan_dirs()
    all_scan_files.extend(dir_files)
    all_scan_files.extend(fnmatch.filter(scan_files, '*.py'))
    all_scan_files = list(set(all_scan_files))

    filter_files = list()
    for file_path in all_scan_files:
        if is_ignore_file(file_path):
            continue
        if not os.path.exists(file_path):
            continue
        filter_files.append(file_path)
    return filter_files


def get_branch_diff_files(source_branch, target_branch):
    try:
        if not source_branch:
            # 获取当前分支
            source_branch = subprocess.check_output(['git', 'rev-parse', '--abbrev-ref', 'HEAD']).strip()

        # 获取 差异文件列表
        diff_files = subprocess.check_output(['git', 'diff', '--name-only', source_branch, target_branch]).splitlines()

        return diff_files, source_branch
    except Exception as e:
        print("分支名错误,请检查重试!")
        print e
        exit(1)


def get_unstaged_files():
    try:
        process = subprocess.Popen(['git', 'diff', '--name-only'], stdout=subprocess.PIPE)
        output, _ = process.communicate()

        files = output.split('\n')
        unstaged_files = [f for f in files if f]

        return unstaged_files
    except Exception as e:
        print "分支名错误,请检查重试!"
        print e
        exit(1)


def load_ignore_patterns_config(args):
    global ignore_patterns
    patterns = os.environ.get('LINT_IGNORE_PATTERNS', '').split(',')
    patterns = [pattern for pattern in patterns if pattern]
    if patterns:
        ignore_patterns.extend(patterns)
    if args.ignore_patterns:
        ignore_patterns.extend(args.ignore_patterns.split(','))

    if ignore_patterns:
        ignore_patterns = list(set(ignore_patterns))


def load_default_files_config():
    global scan_dirs, scan_files
    dirs = os.environ.get('LINT_SCAN_DIRS', '').split(',')
    files = os.environ.get('LINT_SCAN_FILES', '').split(',')

    for d in dirs:
        if os.path.exists(d):
            scan_dirs.append(d)
    for f in files:
        if os.path.exists(f):
            scan_files.append(f)

    if not scan_files and not scan_dirs:
        print '环境变量未设置有效扫描文件:LINT_SCAN_DIRS,LINT_SCAN_FILES'
        exit(0)


def load_branch_files_config(args):
    global scan_files

    diff_files, source_branch = get_branch_diff_files(args.source_branch, args.target_branch)

    if not diff_files:
        print '目前分支:{0}, 源分支:{1},不存在差异文件'.format(args.target_branch, source_branch)
        exit(0)

    scan_files.extend(diff_files)


def load_unstaged_files_config():
    global scan_files

    unstaged_files = get_unstaged_files()

    if not unstaged_files:
        print '不存在未提交文件'
        exit(0)

    scan_files.extend(unstaged_files)


def load_args_files_config(args):
    global scan_files, scan_dirs

    if args.dirs:
        scan_dirs.extend(args.dirs.split(','))

    if args.files:
        scan_files.extend(args.files.split(','))

    if not scan_files and not scan_dirs:
        print '未设置扫描文件: --dirs 或者 --files'
        exit(0)


# 在 gitlab CI/CD  运行时通知到 seatalk 群组
def noti_seatalk():
    url = os.environ.get("LINT_SEATALK_WEBHOOK")
    if not url:
        print "未设置seatalk webhook!"
        return
    user_mail = os.environ.get("GITLAB_USER_EMAIL", "")
    project_name = os.environ.get("CI_PROJECT_NAME", "")
    branch_name = os.environ.get("CI_COMMIT_REF_NAME", "")
    job_url = os.environ.get("CI_JOB_URL", "")
    content = "项目:{project_name}, 分支:{branch_name},代码静态检查发现错误,请及时检查!\n{job_url}".format(
        project_name=project_name, branch_name=branch_name, job_url=job_url
    )
    data = {
        "tag": "text",
        "text": {
            "content": content,
            "mentioned_email_list": [user_mail]
        }
    }
    resp = requests.post(url=url, json=data)
    print '消息发送状态:', resp.content


def main():
    default_mode = "unstaged"
    default_target_branch = "origin/master"
    parser = argparse.ArgumentParser()
    parser.add_argument('-m', '--mode', default=default_mode, required=True, type=str,
                        help='检查模式(支持all,file,branch)')
    parser.add_argument('-d', '--dirs', type=str, default='',
                        help='扫描文件夹(支持多个值,逗号分隔)')
    parser.add_argument('-f', '--files', type=str, default='',
                        help='扫描文件(支持多个值,逗号分隔)')
    parser.add_argument('-t', '--target_branch', type=str, default=default_target_branch,
                        help='对比目标分支(默认为:origin/master)')
    parser.add_argument('-s', '--source_branch', type=str, default='',
                        help='对比源分支(默认为:当前所在分支)')
    parser.add_argument('-i', '--ignore_patterns', type=str, default='',
                        help='忽略扫描文件正则(支持多个值,逗号分隔)')
    parser.add_argument('-n', '--noti_seatalk', type=bool, default=False,
                        help='是否通知到seatalk')

    args = parser.parse_args()

    if not args.mode:
        args.mode = default_mode
    if not args.target_branch:
        args.target_branch = default_target_branch

    support_modes = ['all', 'file', 'branch', 'unstaged']
    if args.mode not in support_modes:
        print "支持的检查模式为:%s" % support_modes
        return

    load_ignore_patterns_config(args)
    if args.mode == "all":
        load_default_files_config()
    elif args.mode == "branch":
        load_branch_files_config(args)
    elif args.mode == "unstaged":
        load_unstaged_files_config()
    else:
        load_args_files_config(args)

    all_files = get_all_scan_files()

    if not all_files:
        print '未有符合扫描的文件!'
        return

    r = Run(all_files, exit=False)

    if args.noti_seatalk and r.linter.msg_status:
        noti_seatalk()

    exit(r.linter.msg_status)


if __name__ == '__main__':
    main()
