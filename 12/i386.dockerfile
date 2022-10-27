FROM i386/ubuntu:14.04

SHELL ["/bin/bash", "--login", "-c"]

ENV NODE_VERSION 12.0.0
ENV YARN_VERSION 1.19.1

ENV NODE_PATH /opt/node-v$NODE_VERSION-linux-x86/lib/node_modules

RUN apt-get update \
  && apt-get -y install build-essential software-properties-common \
  && add-apt-repository -y ppa:git-core/ppa \
  && add-apt-repository -y ppa:ubuntu-toolchain-r/test \
  && apt-get update \
  && apt-get -y install curl gcc-8 git g++-8 make python-dev \
  && apt-get clean
RUN mkdir -p /opt
RUN curl -fksSLO --compressed "https://unofficial-builds.nodejs.org/download/release/v$NODE_VERSION/node-v$NODE_VERSION-linux-x86.tar.gz" \
  && tar -xzf node-v$NODE_VERSION-linux-x86.tar.gz -C /opt/ \
  && ln -s /opt/node-v$NODE_VERSION-linux-x86/bin/node /usr/local/bin/node \
  && ln -s /opt/node-v$NODE_VERSION-linux-x86/bin/npm /usr/local/bin/npm \
  && ln -s /opt/node-v$NODE_VERSION-linux-x86/bin/npx /usr/local/bin/npx \
  && rm node-v$NODE_VERSION-linux-x86.tar.gz
RUN curl -fksSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz" \
  && tar -xzf yarn-v$YARN_VERSION.tar.gz -C /opt/ \
  && ln -s /opt/yarn-v$YARN_VERSION/bin/yarn /usr/local/bin/yarn \
  && ln -s /opt/yarn-v$YARN_VERSION/bin/yarnpkg /usr/local/bin/yarnpkg \
  && rm yarn-v$YARN_VERSION.tar.gz
RUN ln -s --force /usr/bin/gcc-8 /usr/bin/gcc
RUN ln -s --force /usr/bin/g++-8 /usr/bin/g++