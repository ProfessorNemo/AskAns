# frozen_string_literal: true

class UserBulkExportJob < ApplicationJob
  queue_as :default

  # принимаем юзера, который инициировал задачу экспорта
  def perform(initiator)
    # Зазипованный архив. Данный сервисный объект вернет загруженный архив,
    # причем загруженный архив будет образцом класса ActiveStorage.
    stream = UserBulkExportService.call

    Admin::UserMailer.with(user: initiator, stream: stream)
                     .bulk_export_done.deliver_now
  ensure
    # удалим зазипованный архив
    stream.purge
  end
end
