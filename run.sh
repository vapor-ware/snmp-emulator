#!/bin/bash
#
# run.sh
#
# Run the SNMP emulator. This takes one argument - the path of the MIB to
# load and use, e.g. './run.sh mibs/ups'
#

echo "Starting SNMP Emulator"

echo "Arguments:"
for i in "$@"; do
  echo "- $i"
done

echo "Available MIBs:"
for name in mibs/*; do
  echo "- ${name}"
done
echo "-----------------------------"

python "$(command -v snmpsimd.py)" \
    --data-dir="$1" \
    --agent-udpv4-endpoint=0.0.0.0:1024 \
    --v3-user=simulator \
    --v3-auth-key=auctoritas \
    --v3-auth-proto=SHA \
    --v3-priv-key=privatus \
    --v3-priv-proto=AES \
    2>&1
