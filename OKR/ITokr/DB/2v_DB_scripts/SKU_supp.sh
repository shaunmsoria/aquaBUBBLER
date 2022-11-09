#!/bin/bash

rm -f tmp.json

Inventory=$1 
JQ_reference=$2

printf "{" >> tmp.json

while IFS="," read -r SKU Product Supplier Supplier_SKU Supplier_Product_Name Latest_Price Fixed_Price
do
	printf "\n$SKU\n"
	sku=$(jq -r --arg sku_inv "$SKU" '.[] | select(.Legacy == $sku_inv)' $JQ_reference)
	
	description=$(jq -r --arg sku_inv "$SKU" --arg description_inv "$Product" '.[] | select(.Legacy == $sku_inv) | {Description}' $JQ_reference | jq '.Description')
	printf "Description:$description\n"

	if [[ ! -z "$description" ]]; then
		skuStatus="Active"
	else
		skuStatus="Deprecated"
	fi
	printf "Status:$skuStatus\n"

	supplierJ=$(jq -r --arg sku_inv "$SKU" --arg supplier_inv "$Supplier" '.[] | select(.Legacy == $sku_inv) | {Suppliers}' $JQ_reference | jq -r '.[][]')
	printf "SupplierJson:$supplierJ\n"
	supplierI=$Supplier
	printf "SupplierInv:$supplierI\n"
	supplierSKU=$Supplier_SKU
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

	certifications=$(jq -r --arg sku_inv "$SKU" '.[] | select(.Legacy == $sku_inv) | {Certifications}' $JQ_reference | jq -r '.[][]')
	printf "Certification:$certifications\n"

	function=$(jq -r --arg sku_inv "$SKU" '.[] | select(.Legacy == $sku_inv) | {Function}' $JQ_reference | jq -r '.Function' )
	printf "Function:$function\n"

	mbp=$(jq -r --arg sku_inv "$SKU" '.[] | select(.Legacy == $sku_inv) | {MBP}' $JQ_reference | jq -r '.MBP' )
	printf "MBP:$mbp\n"
	
	pctm=$(jq -r --arg sku_inv "$SKU" '.[] | select(.Legacy == $sku_inv) | {PCTM}' $JQ_reference | jq -r '.PCTM' )
	printf "PCTM:$pctm\n"
	
	legacy=$(jq -r --arg sku_inv "$SKU" '.[] | select(.Legacy == $sku_inv) | {Legacy}' $JQ_reference | jq -r '.Legacy' )
	printf "Legacy:$legacy\n"



#	printf "$SKU, $Product, $Supplier, $Supplier_SKU, $Supplier_Product_Name, $Latest_Price, $Fixed_Price\n\n"
done < <(tail -n +2 $Inventory)

