# frozen_string_literal: true

class UserBulkExportService < ApplicationService
  def call
    compressed_filestream = output_stream

    # "Перемотать файл" - прочитать заново и отправить пользователю (rewind) архив "users.zip"
    compressed_filestream.rewind

    # compressed_filestream
    ActiveStorage::Blob.create_and_upload! io: compressed_filestream, filename: 'users.zip'
  end

  private

  # В сервисном объекте не доступен метод render_to_string, а только в контроллере.
  # Для того, чтоб его вызвать, создаем новую переменную "renderer = ActionController::Base.new"
  def output_stream
    renderer = ActionController::Base.new

    # Сгенерировать zip-файл, в котором будут находиться файлы Excel
    # OutputStream - архив, который мы будем пересылать юзеру в ответ на его запрос,
    # при этотом этот архив на диске у нас храниться не будет (временный архив).
    Zip::OutputStream.write_buffer do |zos|
      # Файлы будут создаваться для каждого юзера отдельно:
      User.order(created_at: :desc).each do |user|
        # Затем нам потребуется набрасывать в этот виртуальный архив какие-то файлы (записи).
        # Указываем после "zos.put_next_entry" имя файла, который хотим поместить в архив:
        zos.put_next_entry "user_#{user.id}.xlsx"
        # Сгенерировать excel-файл с помощью метода "render_to_string". Т.е. будем делать строку,
        # которую запишем с помощью "zos.print" в файл. Здесь:
        # handlers - обработчик используемого шаблона, на основе которого формируется конечный файл.
        # Обработчки наз. ":axlsx". template: 'admin/users/user' - представление, которое мы хотим
        # отрендерить и на основе которого сделать строку (представление будет располагаться в 'admin/users/user').
        # locals: { user: user } - локальная переменная, передаваемая представлению, которая будет
        # называться "user", и браться переменная будет из текущего "user". На основе данной переменной
        # сделаем файл Excel.
        zos.print renderer.render_to_string(
          layout: false, handlers: [:axlsx], formats: [:xlsx], template: 'admin/users/user', locals: { user: user }
        )
      end
    end
  end
end

# Если вы не хотите сохранять архив после отправки письма, то можно обойтись без ActiveStorage -
# просто передаем в "user_mailer.rb" объект "compressed_filestream" и делаем "stream.read" для пристыковки к письму
# (без "stream.purge" в "user_bulk_export_job.rb").
# Но в ряде случаев может потребоваться сохранить архив для дальнейших обращений:
# ActiveStorage::Blob.create_and_upload! io: compressed_filestream, filename: 'users.zip'
