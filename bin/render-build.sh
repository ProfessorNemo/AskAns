#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install
yarn install
bundle exec rake assets:precompile
bundle exec rake assets:clean
rails db:migrate:up VERSION=20220824170626
rails db:migrate:up VERSION=20220824170747
rails db:migrate:up VERSION=20220824171409
rails db:migrate:up VERSION=20220824171627
rails db:migrate:up VERSION=20220825232756
rails db:migrate:up VERSION=20220824192334
rake import:from_xlsx
rails db:migrate
rails db:seed