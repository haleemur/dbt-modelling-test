FROM postgres:13.4-bullseye
COPY db_init/ /docker-entrypoint-initdb.d
RUN chmod a+r /docker-entrypoint-initdb.d/*
COPY db_init_data/ /data/
