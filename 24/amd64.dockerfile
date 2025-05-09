FROM rockylinux:8

ENV NODE_VERSION=24.0.0
ENV YARN_VERSION=1.19.1
ENV GIT_VERSION=2.18.0

ENV NODE_PATH=/opt/node-v$NODE_VERSION-linux-x64/lib/node_modules

RUN yum -y install gcc-toolset-14 \
  && yum groupinstall -y 'Development Tools' \
  && yum install -y curl-devel expat-devel gettext-devel openssl-devel perl-CPAN perl-devel wget zlib-devel \
  && yum clean all
RUN mkdir -p /opt
RUN curl -fksSLO --compressed "https://nodejs.org/download/release/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz" \
  && tar -xzf node-v$NODE_VERSION-linux-x64.tar.gz -C /opt/ \
  && ln -s /opt/node-v$NODE_VERSION-linux-x64/bin/node /usr/local/bin/node \
  && ln -s /opt/node-v$NODE_VERSION-linux-x64/bin/npm /usr/local/bin/npm \
  && ln -s /opt/node-v$NODE_VERSION-linux-x64/bin/npx /usr/local/bin/npx \
  && rm node-v$NODE_VERSION-linux-x64.tar.gz
RUN curl -fksSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz" \
  && tar -xzf yarn-v$YARN_VERSION.tar.gz -C /opt/ \
  && ln -s /opt/yarn-v$YARN_VERSION/bin/yarn /usr/local/bin/yarn \
  && ln -s /opt/yarn-v$YARN_VERSION/bin/yarnpkg /usr/local/bin/yarnpkg \
  && rm yarn-v$YARN_VERSION.tar.gz
RUN ln -s --force /opt/rh/gcc-toolset-14/root/bin/gcc /usr/bin/gcc
RUN ln -s --force /opt/rh/gcc-toolset-14/root/bin/g++ /usr/bin/g++
RUN wget https://github.com/git/git/archive/v$GIT_VERSION.tar.gz
RUN tar xvf v$GIT_VERSION.tar.gz

WORKDIR /git-$GIT_VERSION

RUN make configure
RUN ./configure --prefix=/usr/local
RUN make install