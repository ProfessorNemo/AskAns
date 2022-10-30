# frozen_string_literal: true

require 'puma'
require 'puma/daemon'
daemonize

# Puma can serve each request in a thread from an internal thread pool.
# The `threads` method setting takes two numbers: a minimum and maximum.
# Any libraries that use thread pools should be configured to match
# the maximum value specified for Puma. Default is set to 5 threads for minimum
# and maximum; this matches the default thread size of Active Record.
#
max_threads_count = ENV.fetch('RAILS_MAX_THREADS', 5)
min_threads_count = ENV.fetch('RAILS_MIN_THREADS') { max_threads_count }
threads min_threads_count, max_threads_count

if %w[production staging].include? ENV['RAILS_ENV']
  app_dir = File.expand_path('..', __dir__)

  bind "unix://#{app_dir}/tmp/sockets/puma.sock"
  pidfile "#{app_dir}/tmp/pids/puma.pid"
  state_path "#{app_dir}/tmp/pids/puma.state"
else
  port ENV.fetch('PORT', 3000)
end

workers ENV.fetch('WEB_CONCURRENCY', 4)

preload_app!

plugin :tmp_restart
