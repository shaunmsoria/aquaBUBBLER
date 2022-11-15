#!/bin/bash

rm -f test

testFile=$1
testDB=$2

jq -c -r 'keys[]' $testDB | while IFS="" read KEY;
do
	printf "$KEY\n"
	testValue=$(jq -r --arg key "$KEY" '.[$key].SKU' $testDB)
	printf "$testValue\n"

	isPresent=$(jq -r --arg sku "$testValue" '.[] | select(.SKU == $sku ) | {SKU} ' $testFile | jq -r '.SKU')

	if [[ -z "$isPresent"  ]]; then
		printf "$testValue\n" >> test
	fi

#	result=$(jq -r --arg sku "$testValue" '.[] | select(.SKU | contains("$sku")) | {SKU}' $testFile)
#	printf "Result is: $result\n"
done
