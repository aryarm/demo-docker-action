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

COPY ${ENVNAME}/conda-linux-64.lock /tmp
RUN conda create -p /opt/env --copy --file /tmp/conda-linux-64.lock

# TODO: try conda-pack? as described in https://pythonspeed.com/articles/conda-docker-image-size/

# -----------------
# Primary container
# -----------------
# We use 'debug' on distroless so that we can execute test.sh scripts (see https://stackoverflow.com/a/71724405)
FROM gcr.io/distroless/base-debian12:debug
COPY --from=builder /opt/env /opt/env
ENV PATH="/opt/env/bin:${PATH}"
