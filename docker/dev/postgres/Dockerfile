FROM docker.io/postgres:16-bullseye

COPY ./docker/dev/postgres/maintenance /usr/local/bin/maintenance

RUN chmod -R +x /usr/local/bin/maintenance/*

RUN mv /usr/local/bin/maintenance/* /usr/local/bin && \
    rm -rf /usr/local/bin/maintenance

RUN mkdir -p /backups && chown -R postgres:postgres /backups && chmod 777 /backups