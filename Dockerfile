FROM postgres:9.5.4

ENV PGDATA /var/lib/postgresql/data-prepopulated

ADD ./backup/data.tar.gz $PGDATA
