#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install
yarn install
bundle exec rails assets:precompile
bundle exec rails assets:clean
bundle exec rails db:migrate:up VERSION=20220824170626
bundle exec rails db:migrate:up VERSION=20220824170747
bundle exec rails db:migrate:up VERSION=20220824171409
bundle exec rails db:migrate:up VERSION=20220824171627
bundle exec rails db:migrate:up VERSION=20220825232756
bundle exec rails db:migrate:up VERSION=20220824192334
bundle exec rake import:from_xlsx
bundle exec rails db:migrate
bundle exec rails db:seed
