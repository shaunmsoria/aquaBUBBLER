#!/bin/bash

printf "{" >> tmp.json

while IFS="
do
	printf "\"%s\":{\"Description\":\"%s\",\"Supplier\":\"%s\"}," "$SKU" "$Des" "$Supplier" >> tmp.json
done < <(tail -n +2 itemSup.csv)

sed '$ s/.$/}/' tmp.json > itemSup.json

rm -f tmp.json temp.json