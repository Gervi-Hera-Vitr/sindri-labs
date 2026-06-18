#!/usr/bin/env zsh
DIRSTACKSIZE=32
setopt autopushd pushdminus pushdsilent pushdtohome

INVOKED_PATH=$(pwd)
PROJECT_ROOT=$(git rev-parse --show-toplevel)

printf 'Clean Project Parameters:
invocation path : %s
project root    : %s
.. switching to project root.\n\n' $INVOKED_PATH $PROJECT_ROOT

cd $PROJECT_ROOT
git clean -fdx
popd
