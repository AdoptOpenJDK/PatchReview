#!/bin/sh

#
# Copyright (c) 2012, Richard Warburton <richard.warburton@gmail.com>, Graham Allan <grundlefleck@gmail.com> All rights reserved.
# 
# DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
#
# This code is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License version 2 only, as
# published by the Free Software Foundation.  Oracle designates this
# particular file as subject to the "Classpath" exception as provided
# by Oracle in the LICENSE file that accompanied this code.
#
# This code is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
# version 2 for more details (a copy is included in the LICENSE file that
# accompanied this code).
#
# You should have received a copy of the GNU General Public License version
# 2 along with this work; if not, write to the Free Software Foundation,
# Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
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
