# frozen_string_literal: true

class UpdateRateWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'currency', retry: true

  def perform
    begin
      ParseRateService.new.update_rate
    rescue SocketError
      UpdateRateWorker.perform_at(5.minutes)
      return
    end

    UpdateRateWorker.perform_at(1.hour)
  end
end
