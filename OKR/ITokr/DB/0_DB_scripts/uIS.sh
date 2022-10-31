#!/bin/bash

test_json=$(echo "{ }" | jq)
if [ "$test_json" != "{}" ]; then
	echo "jq not installed"
	exit 1
fi

jSource=$1

if [ ! -f "$jSource" ]; then
	echo "config file $jSource not valid"
	exit 2
fi

json=$(cat $jSource)

aJson=()
rm -f tmp.json
rm -f tmp2.json
rm -f tmp3.json
rm -f tmp4.json

readJsonConfig() {
	aJson=$(jq '. | keys' $jSource )
	echo $(jq '.[] += {"MBR":"0", "RQ":"0", "LeadTime":"10"}' $jSource) | jq .  >> tmp.json
	jq . tmp.json >> tmp2.json

	while IFS="^M," read -r SKU2 MBR2 RQ2 LT2 SP2
	do	
#		sFile=$(cat tmp2.json)
#		jq --arg SKU "$SKU2" --arg MBR "$MBR2" --arg RQ "$RQ2" -n '.[$SKU] |= . + {"MBR":$MBR}' <<< "$sFile" 
#		echo "$sFile"
#		echo "$sFile" >> tmp3.json
#		mv tmp3.json tmp2.json

#		jq --arg sku "$SKU2" --arg mbr "$MBR2" '.[$sku] .MBR |= 10' tmp2.json 
		echo $(jq -r --arg SKU "$SKU2" --arg MBR "$MBR2" --arg RQ "$RQ2" --arg LT "$LT2" '.[$SKU] .MBR |= $MBR' tmp2.json) > tmp3.json		
		mv tmp3.json tmp2.json
		echo $(jq -r --arg SKU "$SKU2" --arg MBR "$MBR2" --arg RQ "$RQ2"  --arg LT "$LT2" '.[$SKU] .RQ |= $RQ' tmp2.json) > tmp3.json
		mv tmp3.json tmp2.json

#		jq --arg SKU "$SKU2" --arg MBR "$MBR2" --arg RQ "$RQ2" -n '.[$SKU] |= . + { "MBR":$MBR }' tmp2.json 
#		jq --arg SKU "$SKU2" --arg MBR "$MBR2" --arg RQ "$RQ2" -n '.[$SKU] .MBR |= $MBR' tmp2.json 
#		echo $(jq --arg SKU "$SKU2" --arg MBR "$MBR2" --arg RQ "$RQ2" -n '.[$SKU] |= . + { "MBR": $MBR }' tmp2.json)
	done < <(tail -n +2 MBR_MQ.csv)

#	sFile=$(cat tmp2.json)
#	echo $sFile
#	jq '."R247/N/FX" |= . + {"MBR":10}' <<< "$sFile" > tmp5.json
#	cat tmp5.json
	jq . tmp2.json >> tmp3.json	

}

# jq '."R247/N/FX" |= . + { "MBR":10 }' tmp2.json >> tmp3.json

readJsonConfig


