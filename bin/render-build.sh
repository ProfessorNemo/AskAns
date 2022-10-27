#!usr/bin/env bash
# exit on error
set -o errexit

bundle install
yarn install
bundle exec rake db:migrate:up VERSION=20220824170626
bundle exec rake db:migrate:up VERSION=20220824170747
bundle exec rake db:migrate:up VERSION=20220824171409
bundle exec rake db:migrate:up VERSION=20220824171627
bundle exec rake db:migrate:up VERSION=20220825232756
bundle exec rake db:migrate:up VERSION=20220824192334
bundle exec rake import:from_xlsx
bundle exec rake db:migrate
bundle exec rake db:seed
bundle exec rake assets:precompile
bundle exec rake assets:clean
bundle exec rake db:migrate