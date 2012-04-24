#!/bin/sh

set -eu

count () {
    ls -1 $1 | wc -l
}

echo "Unreviewed Scripts:"
count unreviewed

echo "Reviewed Scripts:"
count reviewed
