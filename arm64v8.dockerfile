FROM alpine AS builder

ENV QEMU_URL https://github.com/balena-io/qemu/releases/download/v3.0.0%2Bresin/qemu-3.0.0+resin-aarch64.tar.gz
RUN apk add curl && curl -L ${QEMU_URL} | tar zxvf - -C . --strip-components 1

FROM arm64v8/ubuntu:14.04

COPY --from=builder qemu-aarch64-static /usr/bin

SHELL ["/bin/bash", "--login", "-c"]

ENV NODE_VERSION 8.5.0
ENV YARN_VERSION 1.19.1

ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH /root/.nvm/versions/node/v$NODE_VERSION/bin:$PATH
ENV PATH /root/.yarn/bin:/root/.config/yarn/global/node_modules/.bin:$PATH

RUN apt-get update
RUN apt-get -y install curl gcc-4.7-arm-linux-gnueabihf gcc-4.7-multilib-arm-linux-gnueabihf git g++-4.7-arm-linux-gnueabihf g++-4.7-multilib-arm-linux-gnueabihf make python-dev
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.1/install.sh | bash
RUN curl -o- -L https://yarnpkg.com/install.sh | bash -s -- --version $YARN_VERSION
RUN ln -s /usr/bin/g++-4.7 /usr/bin/g++
