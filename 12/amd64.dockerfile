FROM centos:centos7

SHELL ["/bin/bash", "--login", "-c"]

ENV NODE_VERSION 12.0.0
ENV YARN_VERSION 1.19.1

ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH /root/.nvm/versions/node/v$NODE_VERSION/bin:$PATH

RUN yum -y install centos-release-scl \
  && yum -y install devtoolset-8-* \
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