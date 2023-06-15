#!/usr/bin/python3
# -*- coding: utf-8 -*-

import argparse
import json
import os
import time

hound_config_dict = {
    "dbpath": "hound_{0}_db".format(int(time.time())),
    "repos": {}
}


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('-p', '--path', required=True, type=str, help='下载路径(绝对路径)')
    args = parser.parse_args()

    if not os.path.exists(args.path):
        print("路径不存在!")

    sub_names = [f for f in os.listdir(args.path) if os.path.isdir(os.path.join(args.path, f))]

    for sub_name in sub_names:
        hound_config_dict["repos"][sub_name] = {
            "url": "file://" + os.path.join(args.path, sub_name)
        }

    with open("hound_{}_config.json".format(int(time.time())), 'w') as f:
        json.dump(hound_config_dict, f)


if __name__ == '__main__':
    main()
