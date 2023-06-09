# -*- coding: utf-8 -*-

import glob
import time

log_files = glob.glob('data_*.log')
output_file = 'merge_data_{0}.log'.format(int(time.time()))

file_positions = {}

while True:
    for log_file in log_files:
        with open(log_file, 'r') as f:
            f.seek(file_positions.get(log_file, 0))
            new_logs = f.readlines()
            if new_logs:
                print('合并文件:%s' % log_file)
                with open(output_file, 'a') as merge_file:
                    merge_file.writelines(new_logs)
                file_positions[log_file] = f.tell()

    time.sleep(1)
