FROM alpine AS builder

ENV QEMU_URL=https://github.com/balena-io/qemu/releases/download/v7.0.0%2Bbalena1/qemu-7.0.0.balena1-arm.tar.gz
RUN apk add curl && curl -L ${QEMU_URL} | tar zxvf - -C . --strip-components 1

FROM arm32v7/centos:centos7

COPY --from=builder qemu-arm-static /usr/bin

ENV NODE_VERSION=12.0.0
ENV YARN_VERSION=1.19.1
ENV GIT_VERSION=2.18.0

ENV NODE_PATH=/opt/node-v$NODE_VERSION-linux-armv7l/lib/node_modules
RUN arch
RUN yum-config-manager --add-repo https://buildlogs.centos.org/c7-devtoolset-12.armhfp
RUN sed -i 's/mirror.centos.org\/altarch/mirror.chpc.utah.edu\/pub\/centos\-altarch/g' /etc/yum.repos.d/*.repo \
  && sed -i 's/mirror.centos.org\/centos/mirror.chpc.utah.edu\/pub\/centos\-altarch/g' /etc/yum.repos.d/*.repo \
  && sed -i s/^exactarch=1/exactarch=0/g /etc/yum.repos.d/*.repo \
  && sed -i s/^#.*baseurl=http/baseurl=http/g /etc/yum.repos.d/*.repo \
  && sed -i s/^mirrorlist=http/#mirrorlist=http/g /etc/yum.repos.d/*.repo
RUN yum -y install --nogpgcheck devtoolset-12 \
  && yum groupinstall -y --nogpgcheck 'Development Tools' \
  && yum install -y --nogpgcheck curl-devel expat-devel gettext-devel openssl-devel perl-CPAN perl-devel wget zlib-devel \
  && yum clean all
RUN mkdir -p /opt
RUN curl -fksSLO --compressed "https://nodejs.org/download/release/v$NODE_VERSION/node-v$NODE_VERSION-linux-armv7l.tar.gz" \
  && tar -xzf node-v$NODE_VERSION-linux-armv7l.tar.gz -C /opt/ \
  && ln -s /opt/node-v$NODE_VERSION-linux-armv7l/bin/node /usr/local/bin/node \
  && ln -s /opt/node-v$NODE_VERSION-linux-armv7l/bin/npm /usr/local/bin/npm \
  && ln -s /opt/node-v$NODE_VERSION-linux-armv7l/bin/npx /usr/local/bin/npx \
  && rm node-v$NODE_VERSION-linux-armv7l.tar.gz
RUN curl -fksSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz" \
  && tar -xzf yarn-v$YARN_VERSION.tar.gz -C /opt/ \
  && ln -s /opt/yarn-v$YARN_VERSION/bin/yarn /usr/local/bin/yarn \
  && ln -s /opt/yarn-v$YARN_VERSION/bin/yarnpkg /usr/local/bin/yarnpkg \
  && rm yarn-v$YARN_VERSION.tar.gz
RUN ln -s --force /opt/rh/devtoolset-12/root/bin/gcc /usr/bin/gcc
RUN ln -s --force /opt/rh/devtoolset-12/root/bin/g++ /usr/bin/g++
RUN wget https://github.com/git/git/archive/v$GIT_VERSION.tar.gz
RUN tar xvf v$GIT_VERSION.tar.gz

WORKDIR /git-$GIT_VERSION

RUN make configure
RUN ./configure --prefix=/usr/local
RUN make install