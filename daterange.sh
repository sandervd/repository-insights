#!/bin/bash
startdate=$1 # e.g. 2013-03-15
enddate=$2 # e.g. 2020-04-14

curr="$startdate"
while true; do
    echo "$curr"
    [ "$curr" \< "$enddate" ] || break
    curr=$( date +%Y-%m-%d --date "$curr +1 day" )
done
