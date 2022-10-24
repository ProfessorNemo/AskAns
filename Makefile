# https://stackoverflow.com/a/14061796/2237879
#
# This hack allows you to run make commands with any set of arguments.
#
# For example, these lines are the same:
#   > make g devise:install
#   > bundle exec rails generate devise:install
# And these:
#   > make migration add_deleted_at_to_users deleted_at:datetime
#   > bundle exec rails g migration add_deleted_at_to_users deleted_at:datetime
# And these:
#   > make model Order user:references record:references{polymorphic}
#   > bundle exec rails g model Order user:references record:references{polymorphic}
#
RUN_ARGS := $(wordlist 2, $(words $(MAKECMDGOALS)), $(MAKECMDGOALS))

drop!:
	rails db:drop

initially:
	rails db:create
	rails db:migrate:up VERSION=20220824170626
	rails db:migrate:up VERSION=20220824170747
	rails db:migrate:up VERSION=20220824171409
	rails db:migrate:up VERSION=20220824171627
	rails db:migrate:up VERSION=20220825232756
	rails db:migrate:up VERSION=20220824192334
	rake import:from_xlsx
	rails db:migrate
	rails db:seed


migration:
	bundle exec rails g migration $(RUN_ARGS)

model:
	bundle exec rails g model $(RUN_ARGS)

create:
	bundle exec rails db:create

migrate:
	bundle exec rails db:migrate

rubocop:
	rubocop -A

web:
	ruby bin/rails server -p 3000

webpacker:
	./bin/webpack-dev-server

run-console:
	bundle exec rails console

rspec:
	bundle exec rspec spec/controllers/password_resets_spec.rb
	bundle exec rspec spec/controllers/questions_spec.rb
	bundle exec rspec spec/controllers/sessions_spec.rb
	bundle exec rspec spec/mailers/password_reset_mailer_spec.rb
	bundle exec rspec spec/models/question_spec.rb
	bundle exec rspec spec/models/user_spec.rb
	bundle exec rspec spec/policies/question_policy_spec.rb
	bundle exec rspec spec/policies/user_policy_spec.rb
	bundle exec rspec spec/policies/admin/user_policy_spec.rb
	bundle exec rspec spec/requests/client_spec.rb
	bundle exec rspec spec/requests/api_json_spec.rb
	bundle exec rspec spec/jobs/user_bulk_export_service_spec.rb
	bundle exec rspec spec/jobs/user_bulk_import_service_spec.rb

redis:
	redis-server

sidekiq:
	bundle exec sidekiq -q default

c: run-console

.PHONY:	db
