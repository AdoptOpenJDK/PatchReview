#!/bin/sh

# $1 = root folder to look for files in
# $2 = jdk folder

matchPackage="([0-9A-Za-z]+\.)+[0-9A-Za-z]+";
classMatch="+[A-Z][A-Za-z0-9]+"

find $1 -type f | grep "\.java$" | while read file
do
  patchPackage=$(egrep -o "[[:space:]]*package[[:space:]]+$matchPackage;" $file | egrep -o "$matchPackage")

  publicClassName=$(egrep -m 1 -o "[[:space:]]*class[[:space:]]$classMatch" $file | egrep -o "$classMatch");

  egrep -o "[[:space:]]*class[[:space:]]$classMatch" $file | egrep -o "$classMatch" | while read class
  do
    #echo "$patchPackage:$publicClassName:$class"
    id=$(serialver -classpath "$2/bin/" $patchPackage.$class 2>/dev/null)
    
    if [[ -z "$id" ]]
    then
      id=$(serialver -classpath "$2/bin/" $patchPackage.$publicClassName.$class 2>/dev/null)
    fi

    if [[ -n "$id" ]]
    then
  id=$(echo $id | egrep -o "serialVersionUID.*");
  echo "$file:$id"
    fi
  done
done
