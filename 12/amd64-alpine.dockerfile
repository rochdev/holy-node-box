FROM node:14.0.0-alpine

RUN apk --no-cache add bash build-base git python curl tar zstd
