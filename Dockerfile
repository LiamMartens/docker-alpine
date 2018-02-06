FROM alpine:3.7
LABEL maintainer="Liam Martens <hi@liammartens.com>"

# @arg USER This will contain the name of the non-root user that will be added
ONBUILD ARG USER

# @env USER This will contain the name of the non-root user that will be added
ONBUILD ENV USER=${USER:-user}
# @env OWN_DIRS This is a list of directories that should be chown'd upon start
ONBUILD ENV OWN_DIRS=${DOCKER_DIR}
# @env OWN_BY This is the chown user and group that will be used for chown upon start
ONBUILD ENV OWN_BY=":${USER}"
# @env SHELL The default shell to use
ONBUILD ENV SHELL=/bin/bash

# @run Update the alpine image
ONBUILD RUN apk update && apk upgrade

# @run Add default packages
ONBUILD RUN apk add tzdata perl curl bash nano git

# @run Add the non-root user
ONBUILD RUN adduser -D ${USER}

# @run create the timezone files
ONBUILD RUN touch /etc/timezone /etc/localtime

# @run chown the timezone files
ONBUILD RUN chown ${USER}:${USER} /etc/timezone /etc/localtime

# @env DOCKER_DIR This is the directory where the run scripts will be stored
ENV DOCKER_DIR=${DOCKER_DIR:-/home/.docker}

# @run create docker dir
RUN mkdir ${DOCKER_DIR}

# @workdir Set the workdir to the docker dir
WORKDIR ${DOCKER_DIR}

# @copy Copy the run files
COPY .docker/* /usr/local/bin

# @run Make executable
RUN chmod -R +x /usr/local/bin/

# @entrypoint
ONBUILD ENTRYPOINT [ "container-init" ]

# @cmd set default cmd to shell
ONBUILD CMD ${SHELL}