FROM quay.io/condaforge/miniforge3:23.3.1-1

ARG ENVNAME

RUN conda config --set channel_priority strict && \
conda config --add channels nodefaults && \
conda config --add channels conda-forge

# ensure separate environment (rather than base environment) is activated upon startup
RUN sed -i 's/activate base$/activate '"${ENVNAME}"'/' /etc/skel/.bashrc && \
sed -i 's/activate base$/activate '"${ENVNAME}"'/' ~/.bashrc

# do not install in base environment but in separate environment!
COPY ${ENVNAME}/environment.yml /tmp
RUN mamba env create -n ${ENVNAME} -f /tmp/environment.yml && \
mamba clean -afy
