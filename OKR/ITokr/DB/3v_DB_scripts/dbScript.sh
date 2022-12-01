#!/bin/bash

rm -f inv_tmp.json BOM_tmp.json

dbFile=$1


printf "[\n" >> inv_tmp.json
printf "[\n" >> BOM_tmp.json

jq -r 'keys[]' $dbFile | while IFS="" read key;
do
	# Creation of the inv_tmp2.json file
	printf "\t{\n" >> inv_tmp.json
	sku=$(jq -r --arg KEY "$key" '.[$KEY].SKU' $dbFile)
	printf "\t\t\"bomSKU\": \"$sku\",\n" >> inv_tmp.json
 	Status=$(jq -r --arg KEY "$key" '.[$KEY].Status' $dbFile)
	if [[ "$Status" == "Active" ]]; then
		printf "\t\t\"Priority\": 1,\n" >> inv_tmp.json
	else
		printf "\t\t\"Priority\": 0,\n" >> inv_tmp.json
	fi
	SupplierSKU=$(jq -r --arg KEY "$key" '.[$KEY].SupplierSKU' $dbFile)
	printf "\t\t\"SupplierSKU\": \"$SupplierSKU\",\n" >> inv_tmp.json
	SupplierProductName=$(jq -r --arg KEY "$key" '.[$KEY].SupplierProductName' $dbFile)
	printf "\t\t\"SupplierProductName\": \"$SupplierProductName\",\n" >> inv_tmp.json
	ItemLatestPrice=$(jq -r --arg KEY "$key" '.[$KEY].ItemLatestPrice' $dbFile)
	printf "\t\t\"ItemLatestPrice\": $ItemLatestPrice,\n" >> inv_tmp.json
	ItemFixedPrice=$(jq -r --arg KEY "$key" '.[$KEY].ItemFixedPrice' $dbFile)
	printf "\t\t\"ItemFixedPrice\": $ItemFixedPrice,\n" >> inv_tmp.json
	RQ=$(jq -r --arg KEY "$key" '.[$KEY].RQ' $dbFile)
	printf "\t\t\"RQ\": $RQ,\n" >> inv_tmp.json
	LeadTime=$(jq -r --arg KEY "$key" '.[$KEY].LeadTime' $dbFile)
	printf "\t\t\"LeadTime\": $LeadTime\n" >> inv_tmp.json
	printf "\t},\n" >> inv_tmp.json

	# Creation of the BOM_tmp.json file
	
	if [[ "$Status" == "Active" ]]; then
		printf "\n\t{\n" >> BOM_tmp.json
		printf "\t\t\"bomSKU\": \"$sku\",\n" >> BOM_tmp.json
		MBR=$(jq -r --arg KEY "$key" '.[$KEY].MBR' $dbFile)
		printf "\t\t\"MBR\": $MBR,\n" >> BOM_tmp.json
		Certifications=$(jq -r --arg KEY "$key" '.[$KEY].Certifications' $dbFile)
		printf "\t\t\"Certifications\": $Certifications,\n" >> BOM_tmp.json
		Function=$(jq -r --arg KEY "$key" '.[$KEY].Function' $dbFile)
		printf "\t\t\"Function\": \"$Function\",\n" >> BOM_tmp.json
		MBP=$(jq -r --arg KEY "$key" '.[$KEY].MBP' $dbFile)
		printf "\t\t\"MBP\": $MBP,\n" >> BOM_tmp.json
		PCTM=$(jq -r --arg KEY "$key" '.[$KEY].PCTM' $dbFile)
		printf "\t\t\"PCTM\": $PCTM,\n" >> BOM_tmp.json
		Legacy=$(jq -r --arg KEY "$key" '.[$KEY].Legacy' $dbFile)
		printf "\t\t\"Legacy\": \"$Legacy\"\n" >> BOM_tmp.json
		printf "\t},\n" >> BOM_tmp.json
	fi

	

done

sed '$ s/.$/]/' inv_tmp.json >> inv_tmp.json
sed '$ s/.$/]/' BOM_tmp.json >> BOM_tmp.json

printf "[\n" >> BOM_tmp2.json

jq -c -r '.[].bomSKU' BOM_tmp.json | while IFS="" read sku;
do
	testSKU=$(jq -r --arg SKU "$sku" '.[] | select(.bomSKU == "$SKU")' BOM_tmp.json)
	if [[ -z "$testSKU" ]]; then
		printf "\n\t{\n" >> BOM_tmp2.json
		printf "\t\t\"bomSKU\": \"$sku\",\n" >> BOM_tmp2.json
		MBR=$(jq -r --arg KEY "$key" '.[$KEY].MBR' $dbFile)
		printf "\t\t\"MBR\": $MBR,\n" >> BOM_tmp2.json
		Certifications=$(jq -r --arg KEY "$key" '.[$KEY].Certifications' $dbFile)
		printf "\t\t\"Certifications\": $Certifications,\n" >> BOM_tmp2.json
		Function=$(jq -r --arg KEY "$key" '.[$KEY].Function' $dbFile)
		printf "\t\t\"Function\": \"$Function\",\n" >> BOM_tmp2.json
		MBP=$(jq -r --arg KEY "$key" '.[$KEY].MBP' $dbFile)
		printf "\t\t\"MBP\": $MBP,\n" >> BOM_tmp2.json
		PCTM=$(jq -r --arg KEY "$key" '.[$KEY].PCTM' $dbFile)
		printf "\t\t\"PCTM\": $PCTM,\n" >> BOM_tmp2.json
		Legacy=$(jq -r --arg KEY "$key" '.[$KEY].Legacy' $dbFile)
		printf "\t\t\"Legacy\": \"$Legacy\"\n" >> BOM_tmp2.json
		printf "\t},\n" >> BOM_tmp2.json
	fi
done
	
sed '$ s/.$/]/' BOM_tmp2.json >> BOM_tmp2.json
