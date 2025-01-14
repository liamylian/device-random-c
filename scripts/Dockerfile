ARG BASE=alpine:3.14
FROM ${BASE} as builder

RUN sed -e 's/dl-cdn[.]alpinelinux.org/mirrors.aliyun.com/g' -i~ /etc/apk/repositories

RUN wget https://iotech.jfrog.io/artifactory/api/security/keypair/public/repositories/alpine-release -O /etc/apk/keys/alpine.dev.rsa.pub
RUN echo 'https://iotech.jfrog.io/artifactory/alpine-release/v3.14/main' >> /etc/apk/repositories
RUN apk add --update --no-cache build-base git gcc cmake make linux-headers yaml-dev libmicrohttpd-dev curl-dev util-linux-dev ncurses-dev paho-mqtt-c-dev-1.3 hiredis-dev

COPY . /device-random
RUN mkdir -p /device-random/build
WORKDIR /device-random

RUN /device-random/scripts/build_deps.sh 1
RUN /device-random/scripts/build.sh


# Next, copy the binaries and headers from the build image above to the final
# runtime image.

FROM ${BASE}
WORKDIR /

RUN sed -e 's/dl-cdn[.]alpinelinux.org/mirrors.aliyun.com/g' -i~ /etc/apk/repositories

RUN wget https://iotech.jfrog.io/artifactory/api/security/keypair/public/repositories/alpine-release -O /etc/apk/keys/alpine.dev.rsa.pub
RUN echo 'https://iotech.jfrog.io/artifactory/alpine-release/v3.14/main' >> /etc/apk/repositories
RUN apk add --update --no-cache linux-headers yaml libmicrohttpd curl libuuid paho-mqtt-c-dev-1.3 hiredis

COPY --from=builder /usr/lib/libcsdk.so /usr/lib
COPY --from=builder /usr/include/devsdk /usr/include/devsdk
COPY --from=builder /usr/include/edgex /usr/include/edgex
COPY --from=builder /usr/include/iot /usr/include/iot
COPY --from=builder /usr/local/include/cbor /usr/local/include/cbor
COPY --from=builder /usr/local/include/cbor.h /usr/local/include/
COPY --from=builder /usr/local/lib/libcbor.so* /usr/local/lib/

COPY --from=builder /device-random/build/release/device-random /

COPY res /res

ENTRYPOINT ["/device-random"]
CMD ["-cp=consul.http://edgex-core-consul:8500", "--registry", "--confdir=/res"]
