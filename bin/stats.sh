#!/bin/sh
# 
# The GNU General Public License (GPL)

# Version 2, June 1991

# Copyright (C) 1989, 1991 Free Software Foundation, Inc.
# 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

# Everyone is permitted to copy and distribute verbatim copies of this license
# document, but changing it is not allowed.
# 

set -eu

count () {
    find $1 -name *.patch | wc -l
}

echo "Unreviewed Scripts:"
count ../unreviewed

echo "Reviewed Scripts:"
count ../reviewed

echo "Further review needed:"
count ../further_review_needed
