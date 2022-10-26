# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  # Rails.application.credentials.dig(:action_mailer, :mail_from)
  default from: ENV.fetch('MAILJET_SENDER', nil)

  layout 'mailer'
end
