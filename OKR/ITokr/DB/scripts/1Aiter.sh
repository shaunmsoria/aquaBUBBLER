#!/bin/bash

file=$1

rm -f tmp.json tmp2.json tmp3.json tmp4.json

printf "{" >> tmp.json

count=0

while IFS='' read ag1; 
do
	printf "\n\t\"Key$count\":\n\t{\n\t\t\"SKU\":\"\",\n\t\t\"Description\":\"\",\n\t\t\"Supplier\":\"\",\n\t\t\"MBR\":\"\",\n\t\t\"RQ\":\"\",\n\t\t\"LeadTime\":\"\",\n\t\t\"Certifications\":\"\",\n\t\t\"Function\":\"\",\n\t\t\"MBP\":\"\",\n\t\t\"Legacy\":$ag1\n\t}," >> tmp.json
	((count=count+1))

done < <(jq -c 'keys[]' $file)

sed '$ s/.$/}/' tmp.json >> tmp2.json

printf "{\n" >> tmp3.json

while IFS='' read value;
do
	lSKU=$(echo $value | jq -r '.Legacy')
	readarray -d / -t skuArr <<< "$lSKU"
	sku=$(printf "${skuArr[0]}")
	description=$(jq -r --arg v "$lSKU" '.[$v].Description' $file)
	supplier=$(jq -r --arg v "$lSKU" '.[$v].Supplier' $file)
	mbr=$(jq -r --arg v "$lSKU" '.[$v].MBR' $file)
	rq=$(jq -r --arg v "$lSKU" '.[$v].RQ' $file)
	leadtime=$(jq -r --arg v "$lSKU" '.[$v].LeadTime' $file)
	tmpCert=${skuArr[1]}
	if [[ "$tmpCert" == "W" ]]; then	
		certifications="Watermark"
	fi
	arrLen=${#skuArr[@]}
	funcTest=""
	function=""
	if [[ "$arrLen" != "1" ]]; then
		funcPosition=$arrLen-1
		funcTest=$(printf "${skuArr[$funcPosition]}")
		if [[ "$funcTest" = "PT" ]]; then
			function="Protection"
		elif [[ "$funcTest" = "FX" ]]; then 
			function="Fixture"
		elif [[ "$funcTest" = "FL" ]]; then 
			function="Flow"
		elif [[ "$funcTest" = "ID" ]]; then 
			function="Identification"
		elif [[ "$funcTest" = "AV" || "$funcTest" == "AC" || "$funcTest" == "AVR"  ]]; then 
			function="Activation"
		elif [[ "$funcTest" = "LB" ]]; then 
			function="LeakBlock"
		fi	
	fi

	printf "$(jq --arg leg "$lSKU" '.[] | select(.Legacy == $leg)' tmp2.json | jq --arg SKU "$sku" --arg des "$description" --arg sup "$supplier" --arg MBR "$mbr" --arg RQ "$rq" --arg lea "$leadtime" --arg cert "$certifications" --arg func "$function"  '. |= . + { "SKU": $SKU } + { "Description": $des } + { "Supplier": $sup } + { "MBR": $MBR } + { "RQ": $RQ } + { "LeadTime": $lea } + {"Certifications": [$cert] } + {"Function": $func }'),\n"  >> tmp3.json
#	printf ",\n" >> tmp3.json



done < <(jq -c '.[]' tmp2.json)


sed '$ s/.$/}/' tmp3.json >> tmp4.json

#jq '.' tmp2.json >> tmp3.json



#jq -c '.' $1 | while read input;
#do
#
#	echo $input | jq "keys"  >> tmp.json
#
##	echo $input | jq '. | to_entries[]' >> tmp.json
##	printf "," >> tmp.json
#	
#
##	printf "{\n\t\"SKU\":\"\",\n\t\"Description\":$(echo $input | jq '.[]."Description"'),\n \
##	\"Supplier\":$(echo $input | jq '."Supplier"'),\n \
##	\"MBR\":$(echo $input | jq '."MBR"'),\n \
##	\"RQ\":$(echo $input | jq '."RQ"'),\n \
##	\"LeadTime\":$(echo $input | jq '."LeadTime"'),\n \
##	\"Legacy\": $(echo $input | jq '.' ) \
##	},\n\
##	" "$input" >> tmp.json
##	cat tmp.json
#
#done

#printf "\n}" >> tmp.json

# echo $input | jq '."Description"'


