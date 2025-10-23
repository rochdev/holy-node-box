FROM node:18.19.0-alpine3.17

RUN apk --no-cache add bash build-base git python3 curl tar zstd
RUN npm install -g npm@9
