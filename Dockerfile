FROM postgres:9.6.1
MAINTAINER yuuhhe

# install curl
RUN apt-get update
RUN apt-get install -y --no-install-recommends \
       ca-certificates \
       curl

# Add Citus repository for package manager
RUN curl https://install.citusdata.com/community/deb.sh | bash

# install the server and initialize db
RUN apt-get -y install postgresql-9.6-citus

# add citus to default PostgreSQL config
RUN echo "shared_preload_libraries='citus'" >> /usr/share/postgresql/postgresql.conf.sample
RUN echo "host all all 0.0.0.0/0 trust" >> /var/lib/postgresql/data/pg_hba.conf

# add scripts to run after initdb
COPY create-citus-extension.sql /docker-entrypoint-initdb.d/
