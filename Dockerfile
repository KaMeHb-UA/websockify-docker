FROM alpine as git

ARG VERSION=latest

RUN apk add --no-cache git

WORKDIR /

RUN git clone https://github.com/novnc/websockify

WORKDIR /websockify

RUN if ! [ "$VERSION" = latest ]; then \
        git checkout "tags/v$VERSION"; \
    fi


FROM alpine

RUN apk add --no-cache py3-numpy py3-requests

RUN ln -s /usr/bin/python3 /usr/bin/python

COPY --from=git /websockify/run /opt/websockify/
COPY --from=git /websockify/websockify/ /opt/websockify/websockify/

# Expose config volumes like in efrecon/websockify repo
VOLUME /opt/websockify/data
VOLUME /opt/websockify/config

# Standard ports
EXPOSE 443
EXPOSE 80

ENTRYPOINT ["/opt/websockify/run"]
