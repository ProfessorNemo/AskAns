# frozen_string_literal: true

class UpdateRateWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'currency', retry: false

  def perform(*)
    begin
      ParseRateService.new.update_rate
    rescue SocketError
      UpdateRateWorker.perform_at(5.minutes, 'Update Rate', 1)
      return
    end

    yaml_service = YamlService.new

    unless yaml_service.get(:is_force)
      rate = yaml_service.get(:current_rate)
      ActionCable.server.broadcast('web_rate_update_channel', content: rate)
    end

    UpdateRateWorker.perform_at(1.hour, 'Update Rate', 1)
  end
end
