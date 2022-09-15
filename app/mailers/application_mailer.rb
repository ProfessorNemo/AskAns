# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.credentials.dig(:action_mailer, :mail_from)

  layout 'mailer'
end
