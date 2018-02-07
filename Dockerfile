FROM alpine:3.7
LABEL maintainer="Liam Martens <hi@liammartens.com>"

# @arg USER This will contain the name of the non-root user that will be added
ONBUILD ARG USER
# @arg SHELL The default shell to be used
ONBUILD ARG SHELL
# @arg TIMEZONE The timezone to use in the container
ONBUILD ARG TIMEZONE

# @env USER This will contain the name of the non-root user that will be added
ONBUILD ENV USER=${USER:-user}
# @env SHELL The default shell to use
ONBUILD ENV SHELL=${SHELL:-/bin/bash}
# @env TIMEZONE The timezone to use
ONBUILD ENV TIMEZONE=${TIMEZONE:-UTC}

# @run Update the alpine image
ONBUILD RUN apk update && apk upgrade

# @run Add default packages
ONBUILD RUN apk add tzdata perl curl bash nano git

# @run Add the non-root user
ONBUILD RUN adduser -D ${USER}

# @run Create the timezone files
ONBUILD RUN touch /etc/timezone /etc/localtime

# @run Chown the timezone files
ONBUILD RUN chown ${USER}:${USER} /etc/timezone /etc/localtime

# @run Save timezone data
ONBUILD RUN cat /usr/share/zoneinfo/${TIMEZONE} > /etc/localtime
ONBUILD RUN echo ${TIMEZONE} > /etc/timezone

# @user Set user
ONBUILD USER ${USER}

# @entrypoint
ONBUILD ENTRYPOINT ${SHELL}