# frozen_string_literal: true

# класс, в котором делать будем импорт (загрузку)
class UserBulkImportJob < ApplicationJob
  # в какую очередь эта задача будет помещена
  queue_as :default

  # м-д выполнения задачи (то, что надо делать в бэкграунде). Принимаем ключ
  # загруженного файла (archive_key) и кто инициировал задачу (initiator)
  def perform(archive_key, url, initiator)
    UserBulkImportService.call archive_key, url
  rescue StandardError => e
    Admin::UserMailer.with(user: initiator, error: e).bulk_import_fail.deliver_now
  else
    Admin::UserMailer.with(user: initiator).bulk_import_done.deliver_now
  end
end

# На адрес юзера который инициировал отправим письмо с сообщением, что задача завершена.
# user: initiator - передаем юзера, которому надо письмо отправить.
# deliver_now - потому что мы и так уже в бэкграунде, поэтому говорить "deliver_later" не нужно.
# "Admin::UserMailer.with(user: initiator).bulk_import_done.deliver_now" - выполнится в том
# случае, если ошибки StandardError не было.
