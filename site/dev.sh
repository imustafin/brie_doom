#!/bin/bash
export JEKYLL_ENV=development
export NODE_ENV=development

# bundle exec jekyll build --config _config.yml,_config.dev.yml,_config.tailwind.yml

bundle exec jekyll serve \
  --config _config.yml,_config.dev.yml \
#  --verbose \
#  --trace \
