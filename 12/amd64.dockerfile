FROM centos:centos7

ENV NODE_VERSION=12.0.0
ENV YARN_VERSION=1.19.1
ENV GIT_VERSION=2.18.0

ENV NODE_PATH=/opt/node-v$NODE_VERSION-linux-x64/lib/node_modules

RUN sed -i s/mirror.centos.org/vault.centos.org/g /etc/yum.repos.d/*.repo \
  && sed -i s/^#.*baseurl=http/baseurl=http/g /etc/yum.repos.d/*.repo \
  && sed -i s/^mirrorlist=http/#mirrorlist=http/g /etc/yum.repos.d/*.repo
RUN yum -y install centos-release-scl
RUN sed -i s/mirror.centos.org/vault.centos.org/g /etc/yum.repos.d/*.repo \
  && sed -i s/^#.*baseurl=http/baseurl=http/g /etc/yum.repos.d/*.repo \
  && sed -i s/^mirrorlist=http/#mirrorlist=http/g /etc/yum.repos.d/*.repo
RUN yum -y install devtoolset-9 \
  && yum groupinstall -y 'Development Tools' \
  && yum install -y curl-devel expat-devel gettext-devel openssl-devel perl-CPAN perl-devel wget zlib-devel \
  && yum clean all

RUN wget https://ftp.gnu.org/gnu/gcc/gcc-10.5.0/gcc-10.5.0.tar.gz
RUN tar -xzvf gcc-10.5.0.tar.gz
RUN cd gcc-10.5.0
RUN ./contrib/download_prerequisites
RUN cd ..
RUN mkdir objdir
RUN cd objdir
RUN ./../gcc-10.5.0/configure --prefix=$HOME/GCC-10.5.0 --disable-multilib
RUN make all-gcc
RUN make all-target-libgcc
RUN make install-gcc
RUN make install-target-libgcc


# RUN mkdir -p /opt
# RUN curl -fksSLO --compressed "https://nodejs.org/download/release/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz" \
#   && tar -xzf node-v$NODE_VERSION-linux-x64.tar.gz -C /opt/ \
#   && ln -s /opt/node-v$NODE_VERSION-linux-x64/bin/node /usr/local/bin/node \
#   && ln -s /opt/node-v$NODE_VERSION-linux-x64/bin/npm /usr/local/bin/npm \
#   && ln -s /opt/node-v$NODE_VERSION-linux-x64/bin/npx /usr/local/bin/npx \
#   && rm node-v$NODE_VERSION-linux-x64.tar.gz
# RUN curl -fksSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz" \
#   && tar -xzf yarn-v$YARN_VERSION.tar.gz -C /opt/ \
#   && ln -s /opt/yarn-v$YARN_VERSION/bin/yarn /usr/local/bin/yarn \
#   && ln -s /opt/yarn-v$YARN_VERSION/bin/yarnpkg /usr/local/bin/yarnpkg \
#   && rm yarn-v$YARN_VERSION.tar.gz
# RUN ln -s --force /opt/rh/devtoolset-9/root/bin/gcc /usr/bin/gcc
# RUN ln -s --force /opt/rh/devtoolset-9/root/bin/g++ /usr/bin/g++
# RUN wget https://github.com/git/git/archive/v$GIT_VERSION.tar.gz
# RUN tar xvf v$GIT_VERSION.tar.gz

# WORKDIR /git-$GIT_VERSION

# RUN make configure
# RUN ./configure --prefix=/usr/local
# RUN make install