# frozen_string_literal: true

# Сервисный объект, который нам позволит заводить пользователей
# в системе на основе Excel
class UserBulkImportService < ApplicationService
  # ключ архива
  attr_reader :archive_key, :service

  # rubocop:disable Lint/MissingSuper
  def initialize(archive_key)
    @archive_key = archive_key
    # сохранить ссылку на сервис
    @service = ActiveStorage::Blob.service
  end
  # rubocop:enable Lint/MissingSuper

  def call
    # ЧИТАЕМ файл
    read_zip_entries do |entry|
      # для каждого файла excel из архива (input_stream) читаем содержимое
      entry.get_input_stream do |f|
        # Нужно создать массив пользователей на основе файла, затем импортировать
        # сразу все и игнорировать дублирующиеся с уже сделанными валидациями
        # https://github.com/zdennis/activerecord-import
        User.import users_from(f.read), validate: true, ignore: true,
                                        validate_with_context: Symbol, all_or_none: true
        f.close
      end
    end
  ensure
    # Это нужно для того, чтобы удалить тот архив, с которым мы уже работали
    # по уникальному ключу (archive_key) после того, как мы с ним завершили работу,
    # чтоб он не висел на диске.
    service.delete archive_key
  end

  private

  def read_zip_entries
    # если блока передано не было
    return unless block_given?

    stream = zip_stream
    # Бесконечный цикл, который будет брать каждый следующий файл из zip
    loop do
      # запись из архива
      entry = stream.get_next_entry

      # если записей больше нет, выходим из цикла
      break unless entry
      # Переходим к следующей итерации если имя не корректное,
      # оно должно заканчиваться на '.xlsx'
      next unless entry.name.end_with? '.xlsx'

      # entry будет передан в м-д "call" (read_zip_entries do |entry|) и для
      # этого мы говорим "yield"
      yield entry
    end
  ensure
    # закрываем поток
    stream.close
  end

  # М-д, выполняющий стриминг загруженного файла .zip
  def zip_stream
    # Получить путь к загруженному архиву из ActiveStorage по его id
    f = File.open service.path_for(archive_key)
    # создаем новый стрим
    stream = Zip::InputStream.new(f)
    # надо закрывать, иначе файл удалить не получится
    f.close
    stream
  end

  # Принимаем конкретные данные из файла
  def users_from(data)
    # распарсить файлик ("[0]" - вытащить 1-й лист из документа)
    sheet = RubyXL::Parser.parse_buffer(data)[0]
    sheet.map do |row|
      # Для каждого ряда нужно вытащить его ячейки. На основе ячеей сделать юзеров.
      cells = row.cells[0..3].map { |c| c&.value.to_s }
      User.new name: cells[0],
               username: cells[1],
               email: cells[2],
               password: cells[3],
               password_confirmation: cells[3]
    end
  end
end
