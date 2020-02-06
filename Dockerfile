FROM alpine as builder

RUN apk add --no-cache git build-base openssl-dev

RUN mkdir /src

WORKDIR /src

RUN git clone https://github.com/novnc/websockify-other.git .

WORKDIR /src/c

RUN make

RUN strip websockify


FROM alpine

RUN apk add --no-cache openssl

COPY --from=builder /src/c/websockify /usr/bin/websockify

ENTRYPOINT [ "/usr/bin/websockify" ]
