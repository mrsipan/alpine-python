FROM alpine:edge

ARG VERSION

ENV PYTHON_URL="https://www.python.org/ftp/python/${VERSION}"
ENV TAR_NAME="Python-${VERSION}.tgz"
ENV PATH /opt/python38/bin:$PATH

RUN set -vex && \
    apk update && \
    apk add libffi sqlite && \
    apk --no-cache add --virtual python-build-deps sqlite-dev \
    g++ make openssl-dev bzip2-dev zlib-dev curl libffi-dev util-linux-dev \
    sqlite-dev readline-dev libuuid ncurses-dev gdbm-dev xz-dev && \
    TEMP_DIR=/tmp/build-python-${RANDOM} && \
    test ! -d ${TEMP_DIR} && \
    mkdir ${TEMP_DIR} && \
    cd ${TEMP_DIR} && \
    curl -L ${PYTHON_URL}/${TAR_NAME} | tar xvz && \
    cd Python-${VERSION} && \
    ./configure --prefix=/opt/python38 --with-ensurepip --enable-shared --enable-ipv6 && \
    make && \
    make install && \
    apk del python-build-deps && \
    rm -rf /var/cache/apk/* && \
    rm -rf /tmp/* && \
    mkdir /build && \
    printf "%s\n" /lib /usr/lib /opt/python38/lib > /etc/ld-musl-x86_64.path

WORKDIR /build

CMD ["python3"]

