#!/bin/sh

set -eux

npx textlint --format json "./src/**/*.tex" | python .github/script/convert.py >./report.json

if [ -s ./report.json ]; then
    cat ./report.json | reviewdog -f=rdjson -reporter=github-pr-review
else
    echo "No errors found"
fi
