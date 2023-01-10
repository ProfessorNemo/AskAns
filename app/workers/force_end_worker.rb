# frozen_string_literal: true

class ForceEndWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'currency'

  def perform(*)
    yaml_service = YamlService.new

    yaml_service.put(:is_force, false)
    rates = yaml_service.get(:current_rate)

    ActionCable.server.broadcast('web_rate_update_channel', content: rates)
  end
end
