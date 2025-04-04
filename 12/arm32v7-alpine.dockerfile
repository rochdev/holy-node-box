FROM alpine AS builder

ENV QEMU_URL=https://github.com/balena-io/qemu/releases/download/v3.0.0%2Bresin/qemu-3.0.0+resin-arm.tar.gz
RUN apk add curl && curl -L ${QEMU_URL} | tar zxvf - -C . --strip-components 1

# zstd is only available starting from 12.9.0 for linux/arm
FROM --platform=linux/arm node:12.9.0-alpine

COPY --from=builder qemu-arm-static /usr/bin

RUN apk --no-cache add bash build-base git python curl tar zstd
