FROM alpine AS builder

ENV QEMU_URL=https://github.com/balena-io/qemu/releases/download/v3.0.0%2Bresin/qemu-3.0.0+resin-aarch64.tar.gz
RUN apk add curl && curl -L ${QEMU_URL} | tar zxvf - -C . --strip-components 1

FROM --platform=linux/arm64 node:12.0.0-alpine

COPY --from=builder qemu-aarch64-static /usr/bin

RUN apk --no-cache add bash build-base git python3 curl tar zstd
