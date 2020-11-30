FROM bitnami/kubectl:1.19
LABEL mantainer "Oleg Basov <olegeech@sytkovo.su>"
USER 0

RUN apt-get update &&\
    DEBIAN_FRONTEND=noninteractive apt-get install -y ncurses-bin && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
COPY knb /usr/bin
COPY starter.sh /usr/bin
ENTRYPOINT ["/usr/bin/starter.sh"]
USER 1001
