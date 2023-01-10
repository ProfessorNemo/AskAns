# frozen_string_literal: true

namespace :worker do
  desc 'Update rate worker'
  task(update_rate: :environment) do
    UpdateRateWorker.perform_async('Update Rate', 1)
  end
end
