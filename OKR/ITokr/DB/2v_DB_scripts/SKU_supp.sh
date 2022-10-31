#!/bin/bash

rm -f tmp.json

Inventory=$1 
JQ_reference=$2

printf "{" >> tmp.json

while IFS="," read -r SKU Product Supplier Supplier_SKU Supplier_Product_Name Latest_Price Fixed_Price
do
	sku_test=""
	printf "$SKU"
	jq -r --arg sku_inv "$SKU" '.[] | select(.Legacy == $sku_inv)' $JQ_reference
#	sku_test=$(jq -r --arg sku_inv "$SKU" '.' $JQ_reference)
#	printf $sku_test
#	if [[  ]];then
#		
#	fi

#	printf "$SKU, $Product, $Supplier, $Supplier_SKU, $Supplier_Product_Name, $Latest_Price, $Fixed_Price\n\n"
done < <(tail -n +2 $Inventory)

