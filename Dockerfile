FROM quay.io/condaforge/miniforge3:23.3.1-1

ARG ENVNAME

RUN conda config --set channel_priority strict && \
conda config --add channels nodefaults && \
conda config --add channels conda-forge

COPY ${ENVNAME}/${ENVNAME}.yml /tmp
RUN mamba env create -n ${ENVNAME} -f /tmp/${ENVNAME}.yml && \
mamba clean -afy

RUN sed -i 's/activate base$/activate ${ENVNAME}/' /etc/skel/.bashrc && \
sed -i 's/activate base$/activate ${ENVNAME}/' ~/.bashrc
