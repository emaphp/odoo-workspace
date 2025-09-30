FROM postgres:17-bullseye

LABEL maintainer="PostGIS Project - https://postgis.net" \
      org.opencontainers.image.description="PostGIS 3.5.2+dfsg-1.pgdg110+1 spatial database extension with PostgreSQL 17 bullseye" \
      org.opencontainers.image.source="https://github.com/postgis/docker-postgis"

ENV POSTGIS_MAJOR=3
ENV POSTGIS_VERSION=3.5.2+dfsg-1.pgdg110+1

ADD https://github.com/pgvector/pgvector.git#v0.8.1 /tmp/pgvector

RUN apt-get update \
      && apt-cache showpkg postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR \
      && apt-get install -y --no-install-recommends \
           # ca-certificates: for accessing remote raster files;
           #   fix: https://github.com/postgis/docker-postgis/issues/307
           ca-certificates \
           \
           postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR=$POSTGIS_VERSION \
           postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR-scripts \
		  && apt-mark hold locales \
		  && apt-get install -y --no-install-recommends build-essential postgresql-server-dev-$PG_MAJOR \
      && cd /tmp/pgvector \
      && make clean \
      && make OPTFLAGS="" \
      && make install \
		  && mkdir /usr/share/doc/pgvector \
      && rm -r /tmp/pgvector \
		  && apt-get remove -y build-essential postgresql-server-dev-$PG_MAJOR \
      && apt-get autoremove -y \
      && apt-mark unhold locales \
      && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /docker-entrypoint-initdb.d
COPY ./initdb-postgis.sh /docker-entrypoint-initdb.d/10_postgis.sh
COPY ./update-postgis.sh /usr/local/bin
