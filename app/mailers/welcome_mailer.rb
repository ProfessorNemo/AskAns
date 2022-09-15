# frozen_string_literal: true

class WelcomeMailer < ApplicationMailer
  # Приветственное сообщение
  def welcome_email
    @user = params[:user]
    @user = @user.decorate
    mail(to: @user.email, subject: I18n.t('welcome_to_mailer.subject'))
  end
end
