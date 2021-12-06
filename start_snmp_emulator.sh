#!/bin/bash

# Start the snmp emulator.

# The snmp emulator cannot run as root.
# Running a python file to load a configuration file will work,
# but then we don't have access to things like snmpsimd.py when we Popen.
# It is not a path issue.

# Arguments are positional:

# Required arguements.
DATA_DIRECTORY=$1 # Where SNMP MIB/OID emulated data lives.
NETWORK_PORT=$2   # Here in order to run multiple emulators.
LOG_DIRECTORY=$3  # Ideally an emulator unique name for logs. Useful for debugging.
SNMP_VERSION=$4   # V1, V2c, V3. Only V3 is currently supported.

# Check required args:

# Enure DATA_DIRECTORY is set
if [ -z ${DATA_DIRECTORY+x} ]; then
  echo "DATA_DIRECTORY is unset";
  exit 1
else echo "DATA_DIRECTORY is set to '${DATA_DIRECTORY}'";
fi

# Enure NETWORK_PORT is set
if [ -z ${NETWORK_PORT+x} ]; then
  echo "NETWORK_PORT is unset";
  exit 1
else echo "NETWORK_PORT is set to '${NETWORK_PORT}'";
fi

# Enure LOG_DIRECTORY is set
if [ -z ${LOG_DIRECTORY+x} ]; then
  echo "LOG_DIRECTORY is unset";
  exit 1
else echo "LOG_DIRECTORY is set to '${LOG_DIRECTORY}'";
fi

# Enure SNMP_VERSION is set
if [ -z ${SNMP_VERSION+x} ]; then
  echo "SNMP_VERSION is unset";
  exit 1
else echo "SNMP_VERSION is set to '${SNMP_VERSION}'";
fi

# Only SNMP V3 is currently suported.
# FUTURE: Support V1 and V2c.
if [[ ${SNMP_VERSION} -ne V3 ]] ; then
  echo "SNMP_VERSION [${SNMP_VERSION}] is not V3"
  exit 1
fi

# Optional arguments, once snmp v1 and v2c are supported.
# Currently these are required as well because we only support:
# V3_SECURITY_LEVEL=authPriv
# V3_AUTHENTICATION_PROTOCOL={SHA | MD5}
# V3_PRIVACY_PROTOCOL={AES | DES}

V3_SECURITY_LEVEL=$5
V3_AUTHENTICATION_PROTOCOL=$6
V3_PRIVACY_PROTOCOL=$7

# Enure V3_SECURITY_LEVEL is set
if [ -z ${V3_SECURITY_LEVEL+x} ]; then
  echo "V3_SECURITY_LEVEL is unset";
  exit 1
else echo "V3_SECURITY_LEVEL is set to '${V3_SECURITY_LEVEL}'";
fi

# Only auth and privacy are currently supported.
# FUTURE: Support noAuthNoPriv and authNoPriv.
if [[ ${V3_SECURITY_LEVEL} -ne authPriv ]] ; then
  echo "V3_SECURITY_LEVEL [${V3_SECURITY_LEVEL}] is not authPriv"
  exit 1
fi

python `which snmpsimd.py` \
    --data-dir=${DATA_DIRECTORY} \
    --agent-udpv4-endpoint=0.0.0.0:${NETWORK_PORT} \
    --v3-user=simulator \
    --v3-auth-key=auctoritas \
    --v3-auth-proto=${V3_AUTHENTICATION_PROTOCOL} \
    --v3-priv-key=privatus \
    --v3-priv-proto=${V3_PRIVACY_PROTOCOL} \
    2>&1 | tee /logs/${LOG_DIRECTORY}
