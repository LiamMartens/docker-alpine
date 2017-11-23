FROM alpine:3.6
LABEL maintainer="Liam Martens <hi@liammartens.com>"

# set default shell, own by and own dirs variables
ARG USER='www-data'
ARG ENV_DIR=/home/docker
# environment
ENV SHELL=/bin/bash
ENV ENV_DIR=${ENV_DIR}
ENV OWN_BY=':www-data'
ENV OWN_DIRS=${ENV_DIR}

# run updates
RUN apk update && apk upgrade

# add default packages
RUN apk add tzdata perl curl bash nano git

# add $USER user
RUN adduser -D ${USER}

# chown timezone files
RUN touch /etc/timezone /etc/localtime && \
    chown ${USER}:${USER} /etc/localtime /etc/timezone

# set workdir
RUN mkdir ${ENV_DIR} ${ENV_DIR}/scripts ${ENV_DIR}/files
# copy script files
# copy run files
COPY scripts/run.sh ${ENV_DIR}/scripts/run.sh
RUN chmod +x ${ENV_DIR}/scripts/run.sh
COPY scripts/continue.sh ${ENV_DIR}/scripts/continue.sh
RUN chmod +x ${ENV_DIR}/scripts/continue.sh

# chown home directory
WORKDIR /home/${USER}
RUN chown -R ${USER}:${USER} ../

# set volume
VOLUME ${ENV_DIR}/files
# set entrypoint
ENTRYPOINT ${ENV_DIR}/scripts/run.sh su -m ${USER} -c ${ENV_DIR}/scripts/continue.sh