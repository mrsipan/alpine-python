FROM alpine:edge

ARG VERSION

ENV PYTHON_URL="https://www.python.org/ftp/python/${VERSION}"
ENV TAR_NAME="Python-${VERSION}.tgz"
ENV PATH /opt/python38/bin:$PATH

RUN set -vex && \
    apk add --update alpine-sdk openssl-dev bzip2-dev zlib-dev && \
    TEMP_DIR=/tmp/build-python-${RANDOM} && \
    test ! -d ${TEMP_DIR} && \
    mkdir ${TEMP_DIR} && \
    cd ${TEMP_DIR} && \
    curl -L ${PYTHON_URL}/${TAR_NAME} | tar xvz && \
    cd Python-${VERSION} && \
    ./configure --prefix=/opt/python38 --with-ensurepip --enable-shared --enable-ipv6 && \
    make && \
    make install && \
    apk del alpine-sdk openssl-dev bzip2-dev zlib-dev && \
    apk add --update openssl && \
    rm -rf /var/cache/apk/* && \
    mkdir /build && \
    printf "%s\n" /opt/python38/lib > /etc/ld-musl-x86_64.path

WORKDIR /build

CMD ["python3"]






