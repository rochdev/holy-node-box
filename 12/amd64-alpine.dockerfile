FROM node:12.0.0-alpine

RUN apk --no-cache add bash build-base git python curl tar zstd
