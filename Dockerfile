FROM quay.io/condaforge/miniforge3:23.3.1-1

ARG envname

RUN conda config --set channel_priority strict && \
    conda config --add channels nodefaults && \
    conda config --add channels conda-forge

COPY ${envname}.yml /tmp
RUN mamba install -n base --file /tmp/${envname}.yml && \
    mamba clean -afy
