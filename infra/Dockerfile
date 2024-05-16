ARG REGISTRY=quay.io
ARG OWNER=jupyter
# Currently only allowing x86_64 in SPCS for right now
ARG BASE_CONTAINER=$REGISTRY/$OWNER/scipy-notebook:latest
FROM $BASE_CONTAINER

LABEL maintainer="Jupyter Project <jupyter@googlegroups.com>"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

USER root

RUN apt-get update --yes && \
    apt-get install --yes --no-install-recommends \
    fonts-dejavu \
    gfortran \
    cmake \
    gcc && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Robynn Specific
RUN apt-get update --fix-missing && apt-get install -y \
    ca-certificates \
    libglib2.0-0 \
    libxext6 \
    libsm6 \
    libxrender1 \
    libxml2-dev

    
COPY ../. /tmp/SPCSDataScience
RUN chown -R ${NB_UID}:${NB_GID} /tmp/SPCSDataScience && \
    chmod -R 755 /tmp/SPCSDataScience

# Installing Robynn
RUN mamba install --yes \
    'r-base' \
    'r-caret' \
    'r-crayon' \
    'r-devtools' \
    'r-e1071' \
    'r-forecast' \
    'r-hexbin' \
    'r-htmltools' \
    'r-htmlwidgets' \
    'r-irkernel' \
    'r-nycflights13' \
    'r-randomforest' \
    'r-rcurl' \
    'r-rmarkdown' \
    'r-rodbc' \
    'r-rsqlite' \
    'r-shiny' \
    'r-tidymodels' \
    'r-tidyverse' \
    'rpy2' \
    'unixodbc' && \
    mamba clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

## copy files
COPY .././infra/install_robyn.R /install_robyn.R

## install packages
RUN Rscript /install_robyn.R

RUN pip install /tmp/SPCSDataScience

USER ${NB_UID}

ENV JUPYTER_TOKEN="my_secure_token"
ENV JUPYTER_PORT=8080

WORKDIR /home/jupyter

ENTRYPOINT ["/bin/bash", "-c", "jupyter lab --allow-root --ip=0.0.0.0 --port=${JUPYTER_PORT} --no-browser --NotebookApp.token=${JUPYTER_TOKEN}"]
