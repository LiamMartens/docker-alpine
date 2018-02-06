FROM alpine:3.7
LABEL maintainer="Liam Martens <hi@liammartens.com>"

# @arg USER This will contain the name of the non-root user that will be added
ONBUILD ARG USER
# @arg SHELL The default shell to be used
ONBUILD ARG SHELL

# @env USER This will contain the name of the non-root user that will be added
ONBUILD ENV USER=${USER:-user}
# @env SHELL The default shell to use
ONBUILD ENV SHELL=${SHELL:-/bin/bash}

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

# @copy Copy the run files
COPY .docker/* /usr/local/bin

# @run Make executable
RUN chmod -R +x /usr/local/bin/

# @entrypoint
ONBUILD ENTRYPOINT [ "container-init" ]

# @cmd set default cmd to shell
ONBUILD CMD ${SHELL}