#!/bin/bash
# 
# The GNU General Public License (GPL)

# Version 2, June 1991

# Copyright (C) 1989, 1991 Free Software Foundation, Inc.
# 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

# Everyone is permitted to copy and distribute verbatim copies of this license
# document, but changing it is not allowed.
# 

#
# Copyright (c) 2012, John Oliver <johno@insightfullogic.com>, Martijn Verburg <martijnverburg@gmail.com> All rights reserved.
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

cd ..

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
WORKING_DIR=$(mktemp -d /tmp/foo.XXXX)
CURRENT_DIR=$(pwd)

#things that are clients
declare -a clientPackages=('java.awt' 'sun.awt' 'javax.swing' 'com.sun.awt' 'sun.swing' 'sun.java2d');





#run file through diffsplit to split multiple diff parts
cd $WORKING_DIR
$SCRIPT_DIR/ojdkdiffsplit.pl -q -s ".patch" $PATCHES_DIR/*.patch
cd $CURRENT_DIR

#process all files output from diffsplit
for patchFile in $WORKING_DIR/*.patch
do
    #find the part of the patch that have the diff line, should be only one as it has been split
    file=`grep "diff.*\.java" $patchFile  | head -n1 | awk '{print $NF}'`

    if [ -f $OPEN_JDK_LOCATION/$file ]
    then
	#get package name from java file
	patchPackage=$(egrep -o "[[:space:]]*package[[:space:]]+$matchPackage;" $OPEN_JDK_LOCATION/$file | egrep -o "$matchPackage")

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

if [[ $WORKING_DIR == /tmp/* ]] 
then
	echo "Cleaning up $WORKING_DIR";
	rm -r $WORKING_DIR
fi
