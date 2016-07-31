FROM prato/autopilot-base:0.1.8

ENV NODE_VER=v6.3.1
ENV NPM_VER=3

# For base builds
# ENV CONFIG_FLAGS="--without-npm" RM_DIRS=/usr/include
# ENV CONFIG_FLAGS="--fully-static --without-npm" DEL_PKGS="libgcc libstdc++" RM_DIRS=/usr/include

RUN apk update; apk add --upgrade \
        make \
        gcc \
        g++ \
        python \
        linux-headers \
        paxctl \
        libgcc \
        libstdc++ \
        gnupg

RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys \
        9554F04D7259F04124DE6B476D5A82AC7E37093B \
        94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
        0034A06D9D9B0064CE8ADF6BF1747F4AD2306D93 \
        FD3A5288F042B6850C66B31F09FE44734EB7990E \
        71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
        DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
        C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
        B9AE9905FFD7803F25714661B63B535A4C206CA9

RUN curl --retry 7 -Lso node-${NODE_VER}.tar.gz \
        "https://nodejs.org/dist/${NODE_VER}/node-${NODE_VER}.tar.gz" \
  && curl -sSL -o SHASUMS256.txt.asc \
        "https://nodejs.org/dist/${NODE_VER}/SHASUMS256.txt.asc" \
  && gpg --verify SHASUMS256.txt.asc \
  && grep node-${NODE_VER}.tar.gz SHASUMS256.txt.asc | sha256sum -c - \
  && tar -zxf node-${NODE_VER}.tar.gz

RUN cd node-${NODE_VER} \
  && export GYP_DEFINES="linux_use_gold_flags=0" \
  && ./configure --prefix=/usr ${CONFIG_FLAGS} \
  && NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) \
  && make -j${NPROC} -C out mksnapshot BUILDTYPE=Release \
  && paxctl -cm out/Release/mksnapshot \
  && make -j${NPROC} \
  && make install \
  && paxctl -cm /usr/bin/node

RUN cd / \
  && if [ -x /usr/bin/npm ]; then \
        npm install -g npm@${NPM_VER} \
        && find /usr/lib/node_modules/npm -name test -o -name .bin -type d \
        | xargs rm -rf; \
  fi \

  && apk del curl make gcc g++ python linux-headers paxctl gnupg ${DEL_PKGS} \
  && rm -rf /etc/ssl /node-${NODE_VER}.tar.gz /SHASUMS256.txt.asc /node-${NODE_VER} ${RM_DIRS} \
    /usr/share/man /tmp/* /var/cache/apk/* /root/.npm /root/.node-gyp /root/.gnupg \
    /usr/lib/node_modules/npm/man /usr/lib/node_modules/npm/doc /usr/lib/node_modules/npm/html
