FROM alpine:3
RUN apk add --no-cache iperf iperf3 nuttcp sysstat && mkdir /data
COPY *.sh /
ENTRYPOINT ["/entrypoint.sh"]
