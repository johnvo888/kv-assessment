#!/usr/bin/env bash
arr=()

currentDate=$(date +"%d-%h-%Y")

echo "$currentDate"

mapfile -t arr <<< "$List_TARGET"

echo "${ZAP_SCAN_OPTIONS}"

for val1 in ${arr[@]}; 
do
    echo $val1
    docker run --rm -v $(pwd):/zap/wrk/:rw -t owasp/zap2docker-stable $ZAP_SCAN_OPTIONS -t https://$val1 -g gen.conf -r reports/${val1}-${currentDate}.html 
done
