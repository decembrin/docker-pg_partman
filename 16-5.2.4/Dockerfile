FROM postgres:16-bullseye

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        gcc \
        make \
        postgresql-server-dev-16 \
        tar \
        wget \
    && rm -rf /var/lib/apt/lists/*

RUN wget -O pg_partman.tar.gz "https://github.com/pgpartman/pg_partman/archive/refs/tags/v5.2.4.tar.gz" \
    \
    && mkdir -p /usr/src/pg_partman \
    && tar \
        --extract \
        --file pg_partman.tar.gz \
        --directory /usr/src/pg_partman \
        --strip-components 1 \
    && rm pg_partman.tar.gz \
    \
    && cd /usr/src/pg_partman \
    && make install \
    \
    && rm -rf /usr/src/pg_partman

COPY ./initdb-pg_partman.sh /docker-entrypoint-initdb.d/10_pg_partman.sh
RUN chmod 755 /docker-entrypoint-initdb.d/10_pg_partman.sh