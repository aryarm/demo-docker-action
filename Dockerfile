FROM quay.io/condaforge/miniforge3:23.3.1-1

ARG ENVNAME

RUN conda config --set channel_priority strict && \
conda config --add channels nodefaults && \
conda config --add channels conda-forge

# ensure separate environment (rather than base environment) is activated upon startup
# this takes advantage of the fact that "conda activate" was added to our .bashrc files in the base image:
# https://github.com/conda-forge/miniforge-images/blob/384bc8e6b047472d9b5ba0054f28e309d3c713e0/ubuntu/Dockerfile#L37-L38
RUN sed -i 's/activate base$/activate '"${ENVNAME}"'/' /etc/skel/.bashrc && \
sed -i 's/activate base$/activate '"${ENVNAME}"'/' ~/.bashrc

# do not install in base environment but in separate environment!
COPY ${ENVNAME}/environment.yml /tmp
RUN mamba env create -n ${ENVNAME} -f /tmp/environment.yml && \
mamba clean -afy
