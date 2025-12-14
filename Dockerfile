FROM alpine:3.22 AS builder
ARG MICROSOCKS_TAG=v1.0.5
ENV MICROSOCKS_URL="https://github.com/rofl0r/microsocks/archive/refs/tags/$MICROSOCKS_TAG.zip"
WORKDIR /build
ADD $MICROSOCKS_URL .
RUN apk add --update --no-cache \
      build-base unzip && \
      unzip $MICROSOCKS_TAG.zip && \
      cd microsocks-${MICROSOCKS_TAG:1} && \
      make && \
      cp ./microsocks ..

FROM golang:1.25.1-alpine AS builder2
RUN apk add --no-cache git
WORKDIR /src
RUN git clone https://github.com/amnezia-vpn/amneziawg-go
WORKDIR /src/amneziawg-go
RUN go build -o /amneziawg .

FROM golang:alpine AS tools
RUN apk update && apk add --no-cache git make bash build-base linux-headers
RUN git clone https://github.com/amnezia-vpn/amneziawg-tools.git
RUN cd amneziawg-tools/src && \
    make

FROM alpine:3.22
ENV HTTPPORT=8080
ENV CONNECTED_CONTAINERS=""
RUN apk add --no-cache iptables ip6tables wireguard-tools-wg-quick privoxy socat
COPY --from=builder2 /amneziawg /usr/bin/amneziawg-go
COPY --from=tools /go/amneziawg-tools/src/wg /usr/bin/awg
COPY --from=tools /go/amneziawg-tools/src/wg-quick/linux.bash /usr/bin/awg-quick


RUN sed -i 's|\[\[ $proto == -4 \]\] && cmd sysctl -q net\.ipv4\.conf\.all\.src_valid_mark=1|[[ $proto == -4 ]] \&\& [[ $(sysctl -n net.ipv4.conf.all.src_valid_mark) != 1 ]] \&\& cmd sysctl -q net.ipv4.conf.all.src_valid_mark=1|' /usr/bin/awg-quick

COPY /additions /
COPY --from=builder /build/microsocks .
HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 CMD /bin/sh /healthcheck.sh
ENTRYPOINT ["/start.sh"]
