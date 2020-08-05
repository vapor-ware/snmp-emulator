FROM vaporio/python:3.8-slim

RUN pip install --no-cache-dir snmpsim

# Ensure the snmpsim has access to the MIB data. Additionally, snmpsim variation
# modules (like writecache) are installed off the search path, so copy to where
# it will be found.
COPY mibs /home/snmpsim/mibs

RUN groupadd -r snmpsim && useradd -r -g snmpsim snmpsim \
 && mkdir -p /home/snmpsim/.snmpsim/variation \
 && cp -r /usr/local/snmpsim/variation/* /home/snmpsim/.snmpsim/variation \
 && chown -R snmpsim:snmpsim /home/snmpsim

WORKDIR /home/snmpsim
USER snmpsim

EXPOSE 1024/udp

ENTRYPOINT ["snmpsimd.py"]
CMD ["--help"]
