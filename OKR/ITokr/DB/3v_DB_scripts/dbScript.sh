#!/bin/bash

rm -f inv_tmp.json inv_tmp2.json BOM_tmp.json

dbFile=$1


printf "[\n" >> inv_tmp.json

jq -c -r 'keys[]' $dbFile | while IFS="" read key;
do
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
done

sed '$ s/.$/]/' inv_tmp.json >> inv_tmp2.json


