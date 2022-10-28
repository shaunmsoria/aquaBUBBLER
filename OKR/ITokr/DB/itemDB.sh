#!/bin/bash

database=$1

rm -f tmp.json tmp2.json

# jq '.' $1

# jq '. | to_entries[] | select( .key | contains("/W/"))' $1 # will only select the Watermark itemsi

## jq '.[] |= . + { "Certifications": [], "Function": "", "Legacy": "" }' $1 >> tmp.json

# jq '.[] | {LeadTime, Certifications}' tmp.json 

# jq '."R247/N/FX"."Certifications" |= ["Watermark"]' tmp.json

# jq '. | to_entries[] | select(.key | contains("/W/"))."Certifications" |= .+ ["Watermark"]' tmp.json


# jq '. | to_entries[] | select(.key | contains("/W/")) |= .value + {"Certifications": ["Watermark"]}' tmp.json


# jq '. | to_entries[] | select(.key | contains("/W/")) |= .value + {"Certifications": ["Watermark"]} + {"Legacy": .key}' tmp.json

jq '. | to_entries[] | select(.key | contains("")) |= .value + {"Legacy": .key}' $1 >> step2.json

jq '.' step2.json
