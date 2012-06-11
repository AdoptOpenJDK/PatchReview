#!/bin/sh

#
# Copyright (c) 2012, John Oliver <johno@insightfullogic.com>, Richard Warburton <richard.warburton@gmail.com> All rights reserved.
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

internal_lines=$(java -version 2>&1 | grep "internal" | wc -l)

if [ $internal_lines -ge 1 ]
then
  echo "Cannot run script against unreleased java build, please check your execution path."
  exit -1
fi

root_folder=$1
jdk_folder=$2

matchPackage="([0-9A-Za-z]+\.)+[0-9A-Za-z]+"
classMatch="+[A-Z][A-Za-z0-9]+"

# foreach java file in the root directory
find $root_folder -type f | grep "\.java$" | while read file
do
  patchPackage=$(egrep -o "[[:space:]]*package[[:space:]]+$matchPackage;" $file | egrep -o "$matchPackage")

  publicClassName=$(egrep -m 1 -o "[[:space:]]*class[[:space:]]$classMatch" $file | egrep -o "$classMatch")

  egrep -o "[[:space:]]*class[[:space:]]$classMatch" $file | egrep -o "$classMatch" | while read class
  do
    id=$(serialver -classpath "jdk_folder/bin/" $patchPackage.$class 2>/dev/null)
    
    if [ -z "$id" ]
    then
      id=$(serialver -classpath "jdk_folder/bin/" $patchPackage.$publicClassName.$class 2>/dev/null)
    fi

    if [ -n "$id" ]
    then
      id=$(echo $id | egrep -o "serialVersionUID.*")
      echo "$file:$id"
    fi
  done
done
