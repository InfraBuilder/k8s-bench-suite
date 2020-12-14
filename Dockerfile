FROM bitnami/kubectl:1.19
LABEL mantainer "Oleg Basov <olegeech@sytkovo.su>"
USER 0

RUN apt-get update &&\
    DEBIAN_FRONTEND=noninteractive apt-get install -y jq ncurses-bin && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives

COPY knb /
COPY docker-entrypoint.sh /
COPY plotly-templates /plotly-templates

ENTRYPOINT ["/docker-entrypoint.sh"]
