#!/bin/sh

# 
# The GNU General Public License (GPL)

# Version 2, June 1991

# Copyright (C) 1989, 1991 Free Software Foundation, Inc.
# 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

# Everyone is permitted to copy and distribute verbatim copies of this license
# document, but changing it is not allowed.
# 

patch_dir=$1
generated_uid_file=$2

grep -oR "serialVersionUID.*" $patch_dir | while read line
do
  file=$(echo $line | cut -d':' -f 1)
  line=$(echo $line | sed 's/.patch//')
  count=$(grep "$line" $generated_uid_file | wc -l)

  if [ $count -lt 1 ]
  then
    echo $line $count
#  else
#    echo $file
  fi
done
