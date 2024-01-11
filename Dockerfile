FROM quay.io/condaforge/miniforge3:23.3.1-1

ARG ENVNAME

RUN conda config --set channel_priority strict && \
conda config --add channels nodefaults && \
conda config --add channels conda-forge

COPY ${ENVNAME}/environment.yml /tmp
RUN mamba env update -n base -f /tmp/environment.yml && \
mamba clean -afy
