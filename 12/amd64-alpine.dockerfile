FROM node:16.13.0-alpine

RUN apk --no-cache add bash build-base git python3 curl tar zstd
RUN npm install -g npm@9
