# Alpine Base
* Based on alpine:3.6

## Arguments
* `USER`: The user to add during build (`www-data` by default)
* `ENV_DIR`: Where to store the starting script files and where to expose the general files volume (`/home/docker` by default, exposes the volume `/home/docker/files`)

## Environment
* `SHELL`: Which shell to start in (`/bin/bash` by default)
* `OWN_DIRS`: What directories to chown upon run (just `$ENV_DIR` by default)
* `OWN_BY`: Who to own the previously stated directories for (`:www-data` by default to keep host user intact)

## Root and user scripts
When attaching the files volume you can define scripts to run as root before the user switches or as the user before the shell is initialized. Put scripts to run as root in the `.root` directory and the user scripts in `.$USER` (inside the files volume). This can be useful to install extra packages during runtime without building a new image.