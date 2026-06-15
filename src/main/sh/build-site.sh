#!/usr/bin/env zsh

INVOKED_PATH=$(pwd)
PROJECT_ROOT=$(git rev-parse --show-toplevel)
SITE_ROOT="$PROJECT_ROOT/site"

printf 'Bundle Build Parameters:
invocation path : %s
project root    : %s
site root       : %s
.. switching to site root.\n\n' $INVOKED_PATH $PROJECT_ROOT $SITE_ROOT

cd $SITE_ROOT
if [[ $(pwd) != $SITE_ROOT ]]; then
  print "Can't make site root."
  cd $INVOKED_PATH
  exit 1
fi

rm -f Gemfile.lock
gem cleanup

bundle config list
bundle config set auto_install true
bundle config set cache_all true
bundle config ignore_funding_requests true --global
bundle config silence_deprecations true
bundle config list

bundle install
bundle exec jekyll clean
bundle exec jekyll build --baseurl "http://127.0.0.1:4400/sindri-labs"
