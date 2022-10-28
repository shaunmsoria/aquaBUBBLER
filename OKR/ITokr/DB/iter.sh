#!/bin/bash

file=$1

rm -f tmp.json tmp2.json 

printf "{" >> tmp.json

count=0

jq -c -r 'keys[]' $file | while IFS='' read lSKU;
do
	readarray -d / -t skuArr <<< "$lSKU"
	sku=$(printf "${skuArr[0]}")
#	echo $sku
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
	testSupplier=$(printf "${supplier[0]}")
	mbp="0"
	pt="0"
	if [[ "$testSupplier" = "ROI" ]]; then
		supplier="Roto Industries Pty Ltd"
		function="Protection"
	elif [[ "$testSupplier" = "Frigmac" ]]; then
		function="Chiller"
	fi
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
	else
#		echo $sku
		readarray -d - -t pbaArr <<< "$sku"
		testPBA=$(printf "${pbaArr[0]}")
		valuePBA=$(printf "${pbaArr[1]}")
#		echo $testPBA
#		echo $valuePBA
		if [[ "$testPBA" = "PBA" ]]; then
			if [[ "$valuePBA" = "10ADG" || "$valuePBA" = "17PDGT" || "$valuePBA" = "18PDG" || "$valuePBA" = "5AVA" || "$valuePBA" = "16PVA" || "$valuePBA" = "39AHF" || "$valuePBA" = "40PSTD" || "$valuePBA" = "41PTTD" || "$valuePBA" = "42PPT" || "$valuePBA" = "43PPS" || "$valuePBA" = "44CRS" || "$valuePBA" = "17PDGT" ]]; then
				rq="10"
				mbp="10"
				pt="10"
			else
				rq="20"
				mbp="20"
				pt="10"
			fi
		fi
	fi
	
	printf "\n\t\"Key$count\":\n\t{\n\t\t\"SKU\":\"$sku\",\n\t\t\"Description\":\"$description\",\n\t\t\"Suppliers\":[\"$supplier\"],\n\t\t\"MBR\":\"$mbr\",\n\t\t\"RQ\":\"$rq\",\n\t\t\"LeadTime\":\"$leadtime\",\n\t\t\"Certifications\":[\"$certifications\"],\n\t\t\"Function\":\"$function\",\n\t\t\"MBP\":\"$mbp\",\n\t\t\"PT\":\"$pt\",\n\t\t\"Legacy\":\"$lSKU\"\n\t}," >> tmp.json
	((count=count+1))
done

sed '$ s/.$/}/' tmp.json >> tmp2.json
