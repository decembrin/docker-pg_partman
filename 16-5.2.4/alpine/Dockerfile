FROM postgres:16-alpine

RUN apk add --no-cache --virtual .build-deps \
    make \
    tar \
    clang19-dev \
    llvm19 \
    g++ \
    gcc 

RUN wget -O pg_partman.tar.gz "https://github.com/pgpartman/pg_partman/archive/refs/tags/v5.2.4.tar.gz"
RUN mkdir -p /usr/src/pg_partman

RUN tar \
    --extract \
    --file pg_partman.tar.gz \
    --directory /usr/src/pg_partman \
    --strip-components 1

RUN cd /usr/src/pg_partman && make install

COPY ./initdb-pg_partman.sh /docker-entrypoint-initdb.d/10_pg_partman.sh
RUN chmod 755 /docker-entrypoint-initdb.d/10_pg_partman.sh