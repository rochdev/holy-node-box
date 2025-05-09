FROM alpine AS builder

ENV QEMU_URL=https://github.com/balena-io/qemu/releases/download/v3.0.0%2Bresin/qemu-3.0.0+resin-aarch64.tar.gz
RUN apk add curl && curl -L ${QEMU_URL} | tar zxvf - -C . --strip-components 1

FROM --platform=arm64 rockylinux:8

COPY --from=builder qemu-aarch64-static /usr/bin

ENV NODE_VERSION=24.0.0
ENV YARN_VERSION=1.19.1
ENV GIT_VERSION=2.18.0

ENV NODE_PATH=/opt/node-v$NODE_VERSION-linux-arm64/lib/node_modules

RUN yum -y install gcc-toolset-14 \
  && yum groupinstall -y 'Development Tools' \
  && yum install -y curl-devel expat-devel gettext-devel git openssl-devel perl-CPAN perl-devel wget zlib-devel \
  && yum clean all
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
RUN ln -s --force /opt/rh/gcc-toolset-14/root/bin/gcc /usr/bin/gcc
RUN ln -s --force /opt/rh/gcc-toolset-14/root/bin/g++ /usr/bin/g++
