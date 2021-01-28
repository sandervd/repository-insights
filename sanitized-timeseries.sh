#!/bin/bash
valuesfile=`mktemp`
git -C $1 log --date=short --pretty=format:%ad | sort | uniq -c | awk '{print $2" "$1}' > $valuesfile
startday=`head -n1 $valuesfile | cut -d' ' -f1`
today=`date +%Y-%m-%d`

daterangefile=`mktemp`
./daterange.sh "$startday" "$today" | awk '{print $1" 0"}' > $daterangefile
sort -t ' ' -k1r $valuesfile $daterangefile | sort -u -k1,1
