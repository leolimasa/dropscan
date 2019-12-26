FROM ubuntu:18.04

COPY ./scripts /root/scripts
COPY ./brscanads2200ads2700w-0.1.15-1.amd64.deb /root/.
RUN /root/scripts/setup_docker.sh
CMD /bin/bash /root/scripts/scan.sh
