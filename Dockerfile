FROM alpine:3.6
LABEL maintainer="Liam Martens <hi@liammartens.com>"

# all statements are onbuild as this is meant to be used as a baseimage

# set default shell, own by and own dirs variables
ONBUILD ARG USER
ONBUILD ARG ENV_DIR
# environment on build
ONBUILD ENV USER=${USER:-www-data}
ONBUILD ENV ENV_DIR=${ENV_DIR:-/home/docker}
ONBUILD ENV OWN_DIRS=${ENV_DIR}
ONBUILD ENV OWN_BY=":${USER}"
# other environment to override after base image build
ENV SHELL=/bin/bash

# run updates
ONBUILD RUN apk update && apk upgrade

# add default packages
ONBUILD RUN apk add tzdata perl curl bash nano git

# add $USER user
ONBUILD RUN adduser -D ${USER}

# chown timezone files
ONBUILD RUN touch /etc/timezone /etc/localtime && \
    chown ${USER}:${USER} /etc/localtime /etc/timezone

# set workdir
ONBUILD RUN mkdir ${ENV_DIR} ${ENV_DIR}/scripts ${ENV_DIR}/files
# copy script files
# copy run files
COPY scripts/run.sh /run.sh
RUN chmod +x run.sh
COPY scripts/continue.sh continue.sh
RUN chmod +x continue.sh
# onbuild move the script and continue files
ONBUILD RUN mv /run.sh ${ENV_DIR}/scripts/run.sh
ONBUILD RUN mv /continue.sh ${ENV_DIR}/scripts/continue.sh

# chown home directory
ONBUILD WORKDIR /home/${USER}
ONBUILD RUN chown -R ${USER}:${USER} ../${USER}

# set volume
ONBUILD VOLUME ${ENV_DIR}/files
# set entrypoint
ONBUILD ENTRYPOINT ${ENV_DIR}/scripts/run.sh su -m ${USER} -c ${ENV_DIR}/scripts/continue.sh