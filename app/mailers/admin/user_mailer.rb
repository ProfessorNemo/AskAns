# frozen_string_literal: true

module Admin
  class UserMailer < ApplicationMailer
    # Считываем того юзера, которому надо что-то отправить
    def bulk_import_done
      @user = params[:user]

      mail to: @user.email, subject: I18n.t('admin.user_mailer.bulk_import_done.subject')
    end

    # М-д, который вызывается, если что-то пошло не так
    def bulk_import_fail
      @error = params[:error]
      @user = params[:user]

      mail to: @user.email, subject: I18n.t('admin.user_mailer.bulk_import_fail.subject')
    end

    # считываем юзера и зазипованный архив, оптравляем письмо, но пристыковываем еще и архив
    # 'result.zip' - имя файла в удобоваримом формате
    # stream.read - контент архива мы читаем и пристыкуем к письму
    def bulk_export_done
      @user = params[:user]
      stream = params[:stream]

      # "attachable_filename" - м-д ActiveStorage, который вернет имя файла в удобоваримом формате.
      # Контент этого архива мы считаем (stream.download) и пристыкуем к письму (attachments)
      attachments[stream.attachable_filename] = stream.download
      # attachments['result.zip'] = stream.read
      mail to: @user.email, subject: I18n.t('admin.user_mailer.bulk_export_done.subject')
    end
  end
end
