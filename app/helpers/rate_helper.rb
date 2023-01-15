# frozen_string_literal: true

module RateHelper
  def current_rate
    # Найти запланированные задания и удалить их
    # https://stackoverflow.com/questions/57859296/how-to-delete-sidekiq-scheduled-job
    ss = Sidekiq::ScheduledSet.new
    jobs = ss.scan('UpdateRateWorker').select { |retri| retri.klass == 'UpdateRateWorker' }
    jobs.each(&:delete)

    UpdateRateWorker.perform_async

    yaml_service.get
  end

  def yaml_service
    @yaml_service ||= YamlService.new
  end
end
