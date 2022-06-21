FROM amd64/ubuntu:14.04

SHELL ["/bin/bash", "--login", "-c"]

ENV NODE_VERSION 8.5.0
ENV YARN_VERSION 1.19.1

ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH /root/.nvm/versions/node/v$NODE_VERSION/bin:$PATH

RUN apt-get update \
  && apt-get -y install curl gcc-4.7 gcc-4.7-multilib git g++-4.7 g++-4.7-multilib make python-dev \
  && apt-get clean
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.1/install.sh | bash
RUN curl -fksSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz" \
  && mkdir -p /opt \
  && tar -xzf yarn-v$YARN_VERSION.tar.gz -C /opt/ \
  && ln -s /opt/yarn-v$YARN_VERSION/bin/yarn /usr/local/bin/yarn \
  && ln -s /opt/yarn-v$YARN_VERSION/bin/yarnpkg /usr/local/bin/yarnpkg \
  && rm yarn-v$YARN_VERSION.tar.gz
