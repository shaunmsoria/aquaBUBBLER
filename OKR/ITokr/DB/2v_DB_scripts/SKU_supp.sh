#!/bin/bash

rm -f inv1.csv inv2.csv tmp.json tmp2.json

file=$1

sed 's/\"//g' $file >> inv1.csv
sed 's///g' inv1.csv >> inv2.csv

Inventory=inv.csv 
JQ_reference=$2



count=0
printf "{" >> tmp.json

while IFS=",\"" read -r SKU Product Supplier Supplier_SKU Supplier_Product_Name Latest_Price Fixed_Price
do
	printf "\n$SKU\n"
	sku=$(jq -r --arg sku_inv "$SKU" '.[] | select(.Legacy == $sku_inv)' $JQ_reference | jq -r '.SKU' )
	
	description=$(jq -r --arg sku_inv "$SKU" --arg description_inv "$Product" '.[] | select(.Legacy == $sku_inv) | {Description}' $JQ_reference | jq -r '.Description')
	printf "Description:$description\n"

	if [[ ! -z "$description" ]]; then
		skuStatus="Active"
	else
		skuStatus="Inactive"
	fi
	printf "Status:$skuStatus\n"

	supplierJ=$(jq -r --arg sku_inv "$SKU" --arg supplier_inv "$Supplier" '.[] | select(.Legacy == $sku_inv) | {Suppliers}' $JQ_reference | jq -r '.[][]')
	printf "SupplierJson:$supplierJ\n"
	supplierI=$Supplier
	printf "SupplierInv:$supplierI\n"
	supplierSKU=$Supplier_SKU
	if [[ "$skuStatus" == "Active" ]]; then
		supplier=$supplierJ
	else
		supplier=$supplierI
	fi
	printf "SupplierSKU:$supplierSKU\n"
	supplierProductName=$Supplier_Product_Name
	printf "SupplierProductName:$supplierProductName\n"
	latestPrice=$Latest_Price
	printf "LatestPrice:$latestPrice\n"
	fixedPrice=$Fixed_Price
	printf "FixedPrice:$fixedPrice\n"

	mbr=$(jq -r --arg sku_inv "$SKU" '.[] | select(.Legacy == $sku_inv) | {MBR}' $JQ_reference | jq -r '.MBR' )
	printf "MBR:$mbr\n"

	rq=$(jq -r --arg sku_inv "$SKU" '.[] | select(.Legacy == $sku_inv) | {RQ}' $JQ_reference | jq -r '.RQ' )
	printf "RQ:$rq\n"

	leadtime=$(jq -r --arg sku_inv "$SKU" '.[] | select(.Legacy == $sku_inv) | {LeadTime}' $JQ_reference | jq -r '.LeadTime' )
	printf "LeadTime:$leadtime\n"

	certificationTest=$(jq -r --arg sku_inv "$SKU" '.[] | select(.Legacy == $sku_inv) | {Certifications}' $JQ_reference | jq -r '.[][]')
	if [[ ! -z "$certificationTest" ]]; then
		certifications=[\"$certificationTest\"]
	else
		certifications=[]
	fi
	printf "Certification:$certifications\n"

	function=$(jq -r --arg sku_inv "$SKU" '.[] | select(.Legacy == $sku_inv) | {Function}' $JQ_reference | jq -r '.Function' )
	printf "Function:$function\n"

	mbp=$(jq -r --arg sku_inv "$SKU" '.[] | select(.Legacy == $sku_inv) | {MBP}' $JQ_reference | jq -r '.MBP' )
	printf "MBP:$mbp\n"
	
	pctm=$(jq -r --arg sku_inv "$SKU" '.[] | select(.Legacy == $sku_inv) | {PCTM}' $JQ_reference | jq -r '.PCTM' )
	printf "PCTM:$pctm\n"
	
	legacy=$(jq -r --arg sku_inv "$SKU" '.[] | select(.Legacy == $sku_inv) | {Legacy}' $JQ_reference | jq -r '.Legacy' )
	printf "Legacy:$legacy\n"



	printf "\n\t\"Key$count\":" >> tmp.json
	printf "\n\t{" >> tmp.json
	printf "\n\t\t\"SKU\":\"$sku\"," >> tmp.json
	printf "\n\t\t\"Description\":\"$description\"," >> tmp.json
	printf "\n\t\t\"Status\":\"$skuStatus\"," >> tmp.json
	printf "\n\t\t\"Supplier\":\"$supplier\"," >> tmp.json
	printf "\n\t\t\"SupplierSKU\":\"$supplierSKU\"," >> tmp.json
	printf "\n\t\t\"SupplierProductName\":\"$Supplier_Product_Name\"," >> tmp.json
	printf "\n\t\t\"ItemLatestPrice\":$latestPrice," >> tmp.json
	printf "\n\t\t\"ItemFixedPrice\":$fixedPrice," >> tmp.json
	printf "\n\t\t\"MBR\":$mbr," >> tmp.json
	printf "\n\t\t\"RQ\":$rq," >> tmp.json
	printf "\n\t\t\"LeadTime\":$leadtime," >> tmp.json
	printf "\n\t\t\"Certifications\":$certifications," >> tmp.json
	printf "\n\t\t\"Function\":\"$function\"," >> tmp.json
	printf "\n\t\t\"MBP\":$mbp," >> tmp.json
	printf "\n\t\t\"PCTM\":$pctm," >> tmp.json
	printf "\n\t\t\"Legacy\":\"$legacy\"" >> tmp.json
	printf "\n\t}," >> tmp.json


	count=$((count+1))
done < <(tail -n +2 $Inventory)

sed '$ s/.$/}/' tmp.json >> tmp2.json
