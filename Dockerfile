FROM python:3.6-alpine3.4

ENV ZENLIB_VERSION v0.4.37
ENV MEDIAINFOLIB_VERSION v18.05
ENV CC /usr/bin/clang
ENV CXX /usr/bin/clang++
ENV SRC /usr

RUN mkdir /tmp/build

RUN \
  apk update && \
  apk add bash zsh git curl wget automake autoconf libtool pkgconfig make gcc zlib-dev libc-dev g++ clang-dev clang

# Install mediainfolib
RUN \
  cd /tmp/build && \
  git clone -b ${ZENLIB_VERSION} https://github.com/MediaArea/ZenLib.git && \
  cd ZenLib/Project/GNU/Library && \
  ./autogen.sh && ./configure --enable-static --prefix="${SRC}" && \
  make -j8 && make install && \
  cp /tmp/build/ZenLib/Project/GNU/Library/libzen-config /bin/libzen-config

RUN \
  cd /tmp/build && \
  git clone -b ${MEDIAINFOLIB_VERSION} https://github.com/MediaArea/MediaInfoLib.git && \
  cd MediaInfoLib/Project/GNU/Library && \
  ./autogen.sh && ./configure --enable-static --prefix="${SRC}" && \
  make -j8 && make install

RUN rm -rf /tmp/build

RUN pip install pymediainfo

ENV LIBRARY_PATH=/lib:/usr/lib:/usr/local/lib

ADD zshrc.minimal .zshrc
SHELL ["bin/zsh"]

