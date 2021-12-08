# SNMP Emulator

A Dockerized SNMP emulator useful for testing and development.

This project is just the Python [`snmpsim`](https://github.com/etingof/snmpsim) package bundled up into a
Docker image along with SNMP MIB walks, making it easy to deploy an emulator for
testing SNMP consumers, such as [Synse](https://synse.readthedocs.io/en/latest/) plugins.

## Getting

```
docker pull vaporio/snmp-emulator
```

## Running

`snmpsim` is run within the container via the [`start_snmp_simulator.sh`](start_snmp_simulator.sh) script.
It provides some lightweight initial context logging to ```/logs/$3``` and then kicks off the simulator
with the following arguments:

```
--data-dir="$1"
--agent-udpv4-endpoint=0.0.0.0:$2
--v3-user=simulator
--v3-auth-key=auctoritas
--v3-auth-proto=$6
--v3-priv-key=privatus
--v3-priv-proto=$7
```

The `--data-dir` argument takes a value passed to the container. This should be the relative path to the
.snmpwalk file that you want to load.

To configure the emulator to run with data from the Pxgms (Eaton) UPS, nulling out the log file:

```
$ docker run vaporio/snmp-emulator /snmp_data/device/ups/pxgms_ups/public.snmpwalk 1024 ../dev/null V3 authPriv SHA AES
```

The agent endpoint always uses the host `0.0.0.0` in order for the container
to properly expose the endpoint.
