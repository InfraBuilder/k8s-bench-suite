FROM alpine:3
RUN apk add --update sysstat && rm -rf /var/cache/apk/* && mkdir /data
COPY *.sh /
CMD ["sh","/monit.sh"]
