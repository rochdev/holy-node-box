FROM alpine AS builder

ENV QEMU_URL https://github.com/balena-io/qemu/releases/download/v3.0.0%2Bresin/qemu-3.0.0+resin-aarch64.tar.gz
RUN apk add curl && curl -L ${QEMU_URL} | tar zxvf - -C . --strip-components 1

FROM arm64v8/centos:centos7

COPY --from=builder qemu-aarch64-static /usr/bin

SHELL ["/bin/bash", "--login", "-c"]

ENV NODE_VERSION 12.0.0
ENV YARN_VERSION 1.19.1

ENV NODE_PATH /opt/node-v$NODE_VERSION-linux-arm64/lib/node_modules

RUN yum -y install centos-release-scl \
  && yum -y install devtoolset-8-* rh-git227-git \
  && yum clean all
RUN scl enable devtoolset-8 bash
RUN mkdir -p /opt
RUN curl -fksSLO --compressed "https://nodejs.org/download/release/v$NODE_VERSION/node-v$NODE_VERSION-linux-arm64.tar.gz" \
  && tar -xzf node-v$NODE_VERSION-linux-arm64.tar.gz -C /opt/ \
  && ln -s /opt/node-v$NODE_VERSION-linux-arm64/bin/node /usr/local/bin/node \
  && ln -s /opt/node-v$NODE_VERSION-linux-arm64/bin/npm /usr/local/bin/npm \
  && ln -s /opt/node-v$NODE_VERSION-linux-arm64/bin/npx /usr/local/bin/npx \
  && rm node-v$NODE_VERSION-linux-arm64.tar.gz
RUN curl -fksSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz" \
  && tar -xzf yarn-v$YARN_VERSION.tar.gz -C /opt/ \
  && ln -s /opt/yarn-v$YARN_VERSION/bin/yarn /usr/local/bin/yarn \
  && ln -s /opt/yarn-v$YARN_VERSION/bin/yarnpkg /usr/local/bin/yarnpkg \
  && rm yarn-v$YARN_VERSION.tar.gz
RUN ln -s --force /opt/rh/devtoolset-8/root/bin/gcc /usr/bin/gcc
RUN ln -s --force /opt/rh/devtoolset-8/root/bin/g++ /usr/bin/g++
RUN ln -s --force /opt/rh/rh-git227/root/usr/bin/git /usr/bin/git