# Note: This Dockerfile is adapted from adapted from
# https://conda.github.io/conda-lock/docker#docker

# -----------------
# Builder container
# -----------------
FROM quay.io/condaforge/miniforge3:23.3.1-1 as builder

RUN conda config --set channel_priority strict && \
conda config --add channels nodefaults && \
conda config --add channels conda-forge

RUN conda create -p /opt/samtools -c conda-forge -c bioconda 'samtools==1.13'

COPY advntr/conda-linux-64.lock /tmp
RUN conda create -p /opt/env --copy --file /tmp/conda-linux-64.lock

# -----------------
# Primary container
# -----------------
FROM ubuntu:bionic

COPY --from=builder /opt/samtools /opt/samtools
COPY --from=builder /opt/env /opt/env

ENV PATH="/opt/env/bin:${PATH}"
