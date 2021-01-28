#!/bin/bash
read line
read -ra PARTS <<< "$line"
repo=${PARTS[0]}
sha=${PARTS[1]}
replace="s#{REPO}#$repo#g;s#{SHA}#$sha#g"
sed $replace Makefile.template
