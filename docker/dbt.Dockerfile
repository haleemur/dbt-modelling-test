from python:3.8-slim as python-base

WORKDIR /dbt_project

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
    # deps for building python deps
    build-essential \
    # pillow deps for matplotlib
    zlib1g-dev \
    libjpeg-dev \
    libffi-dev \
    git \
    # update pip
    && pip install -U pip

RUN pip install dbt==0.19.1

ENV DBT_PROFILES_DIR .profiles
ENTRYPOINT [ "dbt" ]
