#!/bin/sh

RAILS_ENV=production rails assets:precompile
# RAILS_ENV=production rails webpacker:compile
