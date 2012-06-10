#!/bin/sh

patch_dir=$1
generated_uid_file=$2

grep -oR "serialVersionUID.*" $patch_dir | while read line
do
  line=$(echo $line | sed 's/.patch//')
  count=$(grep "$line" $generated_uid_file | wc -l)

  if [ $count -ne 1 ]
  then
    echo $line $count
  fi
done
