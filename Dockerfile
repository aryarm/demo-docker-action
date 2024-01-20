# Note: This Dockerfile is adapted from adapted from
# https://conda.github.io/conda-lock/docker#docker

# -----------------
# Builder container
# -----------------
FROM quay.io/condaforge/miniforge3:23.3.1-1 as builder

ARG ENVNAME

RUN conda config --set channel_priority strict && \
conda config --add channels nodefaults && \
conda config --add channels conda-forge

RUN conda install -c conda-forge conda-pack

COPY ${ENVNAME}/conda-linux-64.lock /tmp
RUN conda create -p /opt/env --copy --file /tmp/conda-linux-64.lock

# Use conda-pack to create a standalone environment in /venv
# https://pythonspeed.com/articles/conda-docker-image-size/
RUN conda-pack -p /opt/env -o /tmp/env.tar.gz && \
mkdir /venv && cd /venv && tar xf /tmp/env.tar.gz && \
rm /tmp/env.tar.gz

# We've put venv in same path it'll be in final image, so now fix up paths:
RUN /venv/bin/conda-unpack

# -----------------
# Primary container
# -----------------
# We use 'debug' on distroless so that we can execute test.sh scripts (see https://stackoverflow.com/a/71724405)
FROM gcr.io/distroless/base-debian12:debug
COPY --from=builder /venv /venv
SHELL ["/busybox/sh", "-c"]
RUN echo hello
ENTRYPOINT . /venv/bin/activate
