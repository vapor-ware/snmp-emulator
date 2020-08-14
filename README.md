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

`snmpsim` is run within the container via the [`run.sh`](run.sh) script. It provides some lightweight
initial context logging and then kicks off the simulator with the following arguments:

```
--data-dir="$1"
--agent-udpv4-endpoint=0.0.0.0:1024
--v3-user=simulator
--v3-auth-key=auctoritas
--v3-auth-proto=SHA
--v3-priv-key=privatus
--v3-priv-proto=AES
```

Currently, the snmp-emulator does not support customizing these configuration options, so ensure any
setup which uses the emulator adheres to the configuration specified above.

The `--data-dir` argument takes a value passed to the container. This should be the relative path to the
MIB (or, more specifically, .snmpwalk file) that you want to load. The currently supported MIBs are found
in the [`mibs`](mibs) subdirectory.

To configure the emulator to run with the UPS MIB, for example:

```
$ docker run vaporio/snmp-emulator mibs/ups
```

Note that the agent endpoint always uses the host `0.0.0.0` in order for the container
to properly expose the endpoint.
