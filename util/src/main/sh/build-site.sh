#!/usr/bin/env zsh

PROJECT_ROOT=$(git rev-parse --show-toplevel)

cd "$PROJECT_ROOT/site" || exit

bundle install && bundle exec jekyll clean && bundle exec jekyll serve --incremental --trace

cd "$PROJECT_ROOT" || exit