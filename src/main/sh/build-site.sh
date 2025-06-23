#!/usr/bin/env zsh

PROJECT_ROOT=$(git rev-parse --show-toplevel)
SITE_ROOT="$PROJECT_ROOT/site"

if [[ "$(pwd)" != "$SITE_ROOT" ]]; then
  exit 1
fi

bundle install && bundle exec jekyll clean && bundle exec jekyll build --baseurl "http://127.0.0.1:4000/sindri-labs"
