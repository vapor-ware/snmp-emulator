FROM docker.io/ubuntu/18.04
#FROM docker.io/vaporio/python:3.9-slim

RUN pip install --no-cache-dir -I snmpsim

# The emulator needs to be run as a non-root user. The snmpsim variation
# modules (like writecache) are installed off the search path, so copy them
# to where they can be found. It seems like snmpsim gets installed with some
# basic MIBs as well - these are removed from the image since their existence
# appears to interfere with the proper loading and usage of the .snmpwalk files
# that we define for the emulator.
RUN groupadd -r snmp && useradd -r -g snmp snmp \
 && mkdir -p /home/snmp/.snmpsim/variation \
 && cp -r /usr/local/snmpsim/variation/* /home/snmp/.snmpsim/variation \
 && rm -rf /usr/local/snmpsim/data \
 && chown -R snmp:snmp /home/snmp

COPY . /home/snmp

WORKDIR /home/snmp
USER snmp

EXPOSE 1024/udp

ENTRYPOINT ["start_snmp_emulator.sh"]
