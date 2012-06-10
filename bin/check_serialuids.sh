#!/bin/sh

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
