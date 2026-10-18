---
type: regex
pattern: '(?:"new_string"|"file_path"\s*:\s*"[^"]*"\s*,\s*"content")\s*:\s*"(?:[^"\\]|\\.)*Read\(\./(?:target|vendor|\.venv|out|coverage)/'
target: trace
match: not_contains
---
