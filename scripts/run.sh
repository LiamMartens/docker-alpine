#!/bin/bash
chown -R $OWN_BY $OWN_DIRS
chmod -R g+ws $OWN_DIRS
# run as root scripts
if [[ -d ${ENV_DIR}/files/.root ]]; then
    chmod +x ${ENV_DIR}/files/.root/*
    run-parts ${ENV_DIR}/files/.root
fi
exec "$@"