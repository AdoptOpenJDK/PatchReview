#!/bin/sh

set -eu

count () {
    find $1 -name *.patch | wc -l
}

echo "Unreviewed Scripts:"
count unreviewed

echo "Reviewed Scripts:"
count reviewed

echo "Further review needed:"
count further_review_needed
