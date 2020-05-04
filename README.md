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

Running a container with no arguments will print out the help info:

```console
$ docker run vaporio/snmp-emulator
Synopsis:
  SNMP Agents Simulation tool. Responds to SNMP requests, variate responses
  based on transport addresses, SNMP community name or SNMPv3 context name.
  Can implement highly complex behavior through variation modules.
Documentation:
  http://snmplabs.com/snmpsim/simulating-agents.html
Usage: /usr/local/bin/snmpsimd.py [--help]
    [--version ]
    [--debug=<io|dsp|msgproc|secmod|mibbuild|mibinstrum|acl|proxy|app|all>]
    [--debug-asn1=<none|encoder|decoder|all>]
    [--daemonize]
    [--process-user=<uname>] [--process-group=<gname>]
    [--pid-file=<file>]
    [--logging-method=<syslog|file|stdout|stderr|null[:args>]>]
    [--log-level=<debug|info|error>]
    [--cache-dir=<dir>]
    [--variation-modules-dir=<dir>]
    [--variation-module-options=<module[=alias][:args]>]
    [--force-index-rebuild]
    [--validate-data]
    [--args-from-file=<file>]
    [--transport-id-offset=<number>]
    [--v2c-arch]
    [--v3-only]
    [--v3-engine-id=<hexvalue>]
    [--v3-context-engine-id=<hexvalue>]
    [--v3-user=<username>]
    [--v3-auth-key=<key>]
    [--v3-auth-proto=<MD5|SHA|SHA224|SHA256|SHA384|SHA512>]
    [--v3-priv-key=<key>]
    [--v3-priv-proto=<3DES|AES|AES128|AES192|AES192BLMT|AES256|AES256BLMT|DES>]
    [--data-dir=<dir>]
    [--max-varbinds=<number>]
    [--agent-udpv4-endpoint=<X.X.X.X:NNNNN>]
    [--agent-udpv6-endpoint=<[X:X:..X]:NNNNN>]
    [--agent-unix-endpoint=</path/to/named/pipe>]

```

Pass in your desired configuration via these flags. You can select which MIB to use
by setting the `--data-dir` option. The snmpwalks defined in the [`mibs/`] subdirectory
are mounted into the container at `/home/snmpsim/mibs`. The image working directory is
`/home/snmpsim`, so to specify the UPS MIB (along with some SNMPv3 config), for example:

```
$ docker run etd/snmpsim \
    --data-dir=mibs/ups \
    --agent-udpv4-endpoint=0.0.0.0:1024 \
    --v3-user=simulator \
    --v3-auth-key=auctoritas \
    --v3-auth-proto=SHA \
    --v3-priv-key=privatus \
    --v3-priv-proto=AES
```

Note that the agent endpoint should always use the host `0.0.0.0` in order for the container
to properly expose the endpoint.
