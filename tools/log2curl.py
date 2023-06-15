# -*- conding: utf-8 -*-
import ast
import sys
import urllib.parse

log = sys.argv[1]

arr = log.split('|')

path = arr[8].strip()
query = ast.literal_eval(arr[10])
body = arr[11].strip()
content = ast.literal_eval(arr[9])

host = content.get("HTTP_X_FORWARDED_HOST", "localhost:8000")
method = content.get("REQUEST_METHOD", "POST")
http_protocol = content.get("HTTP_X_FORWARDED_PROTOCOL", "http")

header_key_prefix = 'HTTP_X_FOODY_'
header_lines = []
if method == "POST":
    header_lines.append("-H 'content-type: application/json'")
for key in content:
    header_key = key.strip()
    if header_key.startswith(header_key_prefix):
        header_key = header_key.replace('_', '-')[5:]
        header_lines.append(
            "-H '{key}: {value}'".format(key=header_key, value=content[key].strip()))

headers = ' \\\n'.join(header_lines)

url = "{http_protocol}://{host}{path}".format(
    http_protocol=http_protocol, host=host, path=path)

if query:
    query_string = urllib.parse.urlencode(query)
    url += "?" + query_string

body_string = ""
if body:
    body_string = "\\\n--data '{body}'".format(body=body)

print("curl -X {method} '{url}' \\\n{headers} {body_string}".format(
    method=method, url=url, headers=headers, body_string=body_string
))
