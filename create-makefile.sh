#!/bin/bash
read line
read -ra PARTS <<< "$line"
repo=${PARTS[0]}
sha=${PARTS[1]}
replace="s#{REPO}#$repo#g;s#{SHA}#$sha#g"
mkdir -p repositories/$sha
sed $replace Makefile.template >> "repositories/$sha/Makefile"
