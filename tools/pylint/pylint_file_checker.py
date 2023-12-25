# -*- coding: utf-8 -*-
import os
import time

from pylint.checkers import BaseChecker
from pylint.interfaces import IAstroidChecker


class FileCountChecker(BaseChecker):
    __implements__ = IAstroidChecker
    scanned_files = []
    name = 'file-count-checker'
    msgs = {
        'I1000': (
            'Files scanned: %s',
            'file-count-scanned',
            'Used to display the number of files scanned.'
        ),
    }

    def __init__(self, linter=None):
        self.scan_ts = 0
        self.start_ts = 0
        self.cur_index = 0
        self.print_progress = False if os.environ.get("LINT_PRINT_PROGRESS") == "false" else True
        super(FileCountChecker, self).__init__(linter)

    def open(self):
        self.start_ts = int(time.time() * 1000)
        self.scan_ts = self.start_ts

    def close(self):
        now_ts = int(time.time() * 1000)
        cost_time = now_ts - self.scan_ts
        total_cost_time = now_ts - self.start_ts
        if self.print_progress:
            print '文件:{0},耗时:{1}ms, 总文件数/已扫描文件数量:{2}/{3}'.format(
                self.scanned_files[-1]["file"],
                cost_time,
                len(self.linter.cmdline_parser.largs),
                len(self.scanned_files),
            )

        print '扫描完成文件数量:{0}, 总耗时:{1:.2f}s'.format(len(self.scanned_files), total_cost_time / 1000.0)

    def visit_module(self, node):
        now_ts = int(time.time() * 1000)
        cost_time = now_ts - self.scan_ts
        self.scan_ts = now_ts
        self.scanned_files.append({
            "file": node.file,
            "last_cost_time": cost_time,
        })

        if len(self.scanned_files) > 1 and self.print_progress:
            print '文件:{0},耗时:{1}ms, 总文件数/已扫描文件数量:{2}/{3}'.format(
                self.scanned_files[self.cur_index - 1]["file"],
                self.scanned_files[self.cur_index]["last_cost_time"],
                len(self.linter.cmdline_parser.largs),
                len(self.scanned_files) - 1,
            )
        self.cur_index += 1


def register(linter):
    linter.register_checker(FileCountChecker(linter))
