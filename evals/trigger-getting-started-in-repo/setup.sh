#!/usr/bin/env bash
set -e
git init -q .
mkdir -p src node_modules/left-pad dist
echo '{"name":"app","scripts":{"test":"node --test","build":"tsc","lint":"eslint ."}}' > package.json
echo 'export const add = (a, b) => a + b' > src/add.js
