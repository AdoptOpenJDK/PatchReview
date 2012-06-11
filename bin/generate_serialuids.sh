#!/bin/sh
# 
# The GNU General Public License (GPL)

# Version 2, June 1991

# Copyright (C) 1989, 1991 Free Software Foundation, Inc.
# 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

# Everyone is permitted to copy and distribute verbatim copies of this license
# document, but changing it is not allowed.
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
