ARG JLVERSION=1.8.2
ARG PYVERSION=3.10.8
ARG CLOUD_SDK_VERSION=412.0.0
ARG BASE_IMAGE=bullseye

FROM julia:${JLVERSION}-${BASE_IMAGE} AS jl
FROM python:${PYVERSION}-${BASE_IMAGE}

# Merge Julia image:
COPY --from=jl /usr/local/julia /usr/local/julia
ENV PATH="/usr/local/julia/bin:${PATH}"

USER root

# Install required packages

RUN apt-get -y update && apt-get -y upgrade && apt-get -y autoremove && apt-get -y clean && apt-get install -y \
    software-properties-common \
    curl \
    libcurl3-dev\
    wget\
    zip\
    unzip\
    git\
    vim\
    pkg-config\
    rsync\
    libatlas-base-dev\
    liblapack-dev\
    libpng-dev\
    libjpeg-dev\
    gfortran\
    python3.5\
    python3-dev\
    python3-pip\
    python3-setuptools\
    python2.7\
    python-dev\
    python-setuptools\
    gdb\
    g++\
    libio-all-perl\
    libsnappy-dev\
    libyaml-0-2\
    python-opencv


# Instalando Cloud SDK Google: Beging of https://hub.docker.com/r/google/cloud-sdk/dockerfile
#https://cloud.google.com/sdk/docs/release-notes
ENV CLOUD_SDK_VERSION=$CLOUD_SDK_VERSION

RUN apt-get -qqy update && apt-get install -qqy \
#	wget \
#        curl \
#        python-setuptools \
        apt-transport-https \
        lsb-release \
        openssh-client \
        gnupg && \
    export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" && \
    echo "deb https://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" > /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    apt-get update && \
    apt-get install -y google-cloud-sdk=${CLOUD_SDK_VERSION}-0 \
        google-cloud-sdk-cbt=${CLOUD_SDK_VERSION}-0 \
        kubectl && \
    gcloud config set core/disable_usage_reporting true && \
    gcloud config set component_manager/disable_update_check true && \
    gcloud config set metrics/environment github_docker_image && \
    gcloud --version && \
    kubectl version --client

# Instalando Cloud SDK Google: END OF https://hub.docker.com/r/google/cloud-sdk/dockerfile

RUN groupadd --gid 1000 node && useradd --uid 1000 --gid node --shell /bin/bash --create-home node
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - && apt-get install -y nodejs build-essential

#---- TODO: In this part makes sense to insert the requeriments as parameter. 

COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt

# Install Julia pre-requisites:
RUN python3 -c 'import pysr; pysr.install()'

RUN groupadd --gid 1001 jupyterlab && useradd --uid 1001 --gid jupyterlab --shell /bin/bash --create-home jupyterlab && \
pip install jupyter ipywidgets jupyter_nbextensions_configurator && \
jupyter nbextension enable --py widgetsnbextension && jupyter nbextensions_configurator enable --user && \
jupyter contrib nbextension install && jupyter nbextension enable --py widgetsnbextension && \
jupyter serverextension enable --py jupyterlab --sys-prefix

RUN jupyter labextension install @jupyterlab/git && pip install --upgrade jupyterlab-git && \
jupyter serverextension enable --py jupyterlab_git

ENV LANG=C.UTF-8

ENV PATH "${PATH}:/root/gcloud/google-cloud-sdk/bin"

RUN echo "export PATH=\$PATH:/root/gcloud/google-cloud-sdk/bin" >> /root/.bashrc

EXPOSE 80

RUN mkdir -p /root/notebooks

RUN python -m bash_kernel.install

CMD jupyter-notebook --ip=0.0.0.0 --port=80 --no-browser --NotebookApp.token='' --NotebookApp.password='' --notebook-dir=/root/notebooks --allow-root > log.file

