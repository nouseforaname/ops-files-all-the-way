#!/bin/bash
set -x
SUBNETS=$(terraform state list | grep 'subnet.*az.*' | sed 's/.*\.//' )
for subnet in $SUBNETS; do
  JSON=$JSON"$(
  echo "\"$subnet\":"
  terraform state show "aws_subnet.$subnet" |
    sed 's/[[:blank:]]*= /: /' |
    sed 's/tags.*//' |
    spruce json),"
done
bosh int <(echo "{"${JSON::-1}"}" | jq 'to_entries 
     | map({
       "type": "replace",
       "path": "/networks/name=\(.key | sub("_az_.";""))?/subnets/-",
       "value": {
         "range": .value.cidr_block,
         "dns": "4.4.4.4", 
         "az": .value.availability_zone,
         "gateway": "\(.value.cidr_block | gsub ("0*/[0-9]*";"1"))",
         "cloud_properties": {"subnet": .value.id }
       }
       })') > ops-files/networks-ops-file.yml

bosh int <(echo "{"${JSON::-1}"}" | jq 'to_entries 
     | map({
       "type": "replace",
       "path": "/azs/name=\(.value.availability_zone)?",
       "value": {
         "name": .value.availability_zone,
         "cloud_properties": {"availability_zone": .value.availability_zone}
       }
      })') > ops-files/azs-ops-file.yml

