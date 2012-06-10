#!/bin/bash

# $1 = dir with patches
# $2 = file with generated UID's

grep -oR "serialVersionUID.*" $1 | while read line
do
  count=$(grep "$line" $2 | wc -l)

  if [[ $count -ne 1 ]]
  then
    echo $line $count
  fi
done
