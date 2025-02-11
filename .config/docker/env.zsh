# This sucks but it appears docker desktop doesn't respect $DOCKER_CONFIG in an effort to keep the CLI and docker
# desktop in sync set this to the default location for now.
#
# @see https://github.com/docker/for-mac/issues/2635
export DOCKER_CONFIG=$HOME/.docker
