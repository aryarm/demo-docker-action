# Note: This Dockerfile is adapted from adapted from
# https://conda.github.io/conda-lock/docker#conda-lock-inside-a-build-container

# -----------------
# Builder container
# -----------------
FROM quay.io/condaforge/miniforge3:23.3.1-1 as builder

ARG ENVNAME

RUN conda config --set channel_priority strict && \
conda config --add channels nodefaults && \
conda config --add channels conda-forge

# do not install in base environment but in separate environment!
COPY ${ENVNAME}/environment.yml /tmp

RUN mamba create -n lock 'conda-forge::conda-lock==2.5.1' && \
conda run -n lock conda-lock lock \
    --platform linux-64 \
    --file /tmp/environment.yml \
    --kind lock \
    --lockfile /tmp/conda-lock.yml

RUN conda run -n lock conda-lock install \
    --mamba \
    --copy \
    --prefix /opt/env \
    /tmp/conda-lock.yml

# TODO: try conda-pack? as described in https://pythonspeed.com/articles/conda-docker-image-size/

# -----------------
# Primary container
# -----------------
FROM gcr.io/distroless/base-debian10
COPY --from=builder /opt/env /opt/env
ENV PATH="/opt/env/bin:${PATH}"
