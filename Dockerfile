FROM alpine as git

RUN apk add --no-cache git

WORKDIR /

RUN git clone https://github.com/novnc/websockify


FROM alpine

RUN apk add --no-cache py3-numpy py3-requests

RUN env PYPATH=$(which python3) ln -s "$PYPATH" $(dirname "$PYPATH")/python

COPY --from=git /websockify/run /opt/websockify/
COPY --from=git /websockify/websockify/ /opt/websockify/websockify/

# Expose config volumes like in efrecon/websockify repo
VOLUME /opt/websockify/data
VOLUME /opt/websockify/config

# Standard ports
EXPOSE 443
EXPOSE 80

ENTRYPOINT ["/opt/websockify/run"]
