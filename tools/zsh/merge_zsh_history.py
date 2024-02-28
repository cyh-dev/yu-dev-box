#!/usr/bin/env python3
import os
import sys

if len(sys.argv) != 3:
    print("Usage: python merge_history.py file1 file2")
    sys.exit(1)

file1 = sys.argv[1]
file2 = sys.argv[2]

if not os.path.isfile(file1):
    print(f"{file1} does not exist or is not a file")
    sys.exit(1)

if not os.path.isfile(file2):
    print(f"{file2} does not exist or is not a file")
    sys.exit(1)

history = {}

# Read the first file and add entries to the history dictionary
with open(file1, "r", encoding="ISO-8859-1") as f:
    for line in f:
        if line.startswith(":"):
            try:
                cmd = line.strip().split(";")[1]
                history[cmd] = line.strip()
            except UnicodeDecodeError:
                pass

# Read the second file and add entries to the history dictionary
with open(file2, "r", encoding="ISO-8859-1") as f:
    for line in f:
        if line.startswith(":"):
            try:
                cmd = line.strip().split(";")[1]
                history[cmd] = line.strip()
            except UnicodeDecodeError:
                pass

# Sort the history entries by timestamp and print them to stdout
for line in sorted(history.values()):
    print(line)
