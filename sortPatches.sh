#!/bin/bash


if [ $# -ne 3 ]
then
  echo "Usage: $0 <dir containing patches> <output dir> <location of jdk source>"
  echo "i.e: $0 ./patches ./sortedPatches ../OpenJDK/jdk"
  exit 1
fi

if [ ! -d $1 ]
then
    echo "Patch directory does not exist"
    exit 2;
elif [ ! -d $3 ]
then
    echo "OpenJdk source directory does not exist"
    exit 2;
fi

PATCHES_DIR=`cd $1; pwd`
OUTPUT_LOCATION=$2
OPEN_JDK_LOCATION=$3

#regex to match packages
matchPackage="([0-9A-Za-z]+\.)+[0-9A-Za-z]+";

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
WORKING_DIR=$(mktemp -d)
CURRENT_DIR=$(pwd)

#things that are clients
declare -a clientPackages=('java.awt' 'sun.awt' 'javax.swing' 'com.sun.awt' 'sun.swing' 'sun.java2d');





#run file through diffsplit to split multiple diff parts
cd $WORKING_DIR
$SCRIPT_DIR/ojdkdiffsplit -q -s ".patch" $PATCHES_DIR/*.patch
cd $CURRENT_DIR

#process all files output from diffsplit
for patchFile in $WORKING_DIR/*.patch
do
    #find the part of the patch that have the diff line, should be only one as it has been split
    file=`grep "diff.*\.java" $patchFile  | head -n1 | awk '{print $NF}'`

    if [ -f $OPEN_JDK_LOCATION/$file ]
    then
	#get package name from java file
	patchPackage=$(egrep -o "\s*package\s+$matchPackage;" $OPEN_JDK_LOCATION/$file | egrep -o "$matchPackage")

	if [[ -z "$patchPackage" ]]
	then
	  echo "No package found for patch $patchFile";
	else
	  clientOrCore="core"
	  for pattern in ${clientPackages[@]}
	  do
	    if [[ "$patchPackage" =~ "$pattern" ]]
	    then
	      clientOrCore="client"
	    fi
	  done

	  patchLocation=$(echo $patchPackage | sed 's/\./\//g');

	  #copy file to the right location
	  mkdir -p $OUTPUT_LOCATION/$clientOrCore/$patchLocation;
	  cp $patchFile $OUTPUT_LOCATION/$clientOrCore/$patchLocation/
	fi
    else
	echo "Could not find file $OPEN_JDK_LOCATION/$file";
    fi
done

echo "Cleaning up $WORKING_DIR";
rm -rI --preserve-root $WORKING_DIR
