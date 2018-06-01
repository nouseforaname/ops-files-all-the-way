#!/bin/bash
SECGRPS=$(terraform state list | grep 'security' | sed 's/.*\.//')
for secgrp in $SECGRPS; do
  JSON=$JSON"$(
  echo "\"$secgrp\":"
  terraform state show "aws_security_group.$secgrp" |
  sed 's/[[:blank:]]*= /: /' |
  sed 's/tags.*//' |
  spruce json),"

done
bosh int <(echo "{"${JSON::-1}"}" | jq 'to_entries| map({"type": "replace", path: "/vm_extensions?/name=\(.value.name)?", value: {name: .value.name , cloud_properties: {"security_groups": ["\(.value.name)"]}}})') > ops-files/secgrp-ops-file.yml


