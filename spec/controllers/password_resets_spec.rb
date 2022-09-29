# frozen_string_literal: true

RSpec.describe PasswordResetsController, type: :controller do
  describe 'reset_created' do
    let(:user) do
      User.new email: Faker::Internet.email,
               name: Faker::Name.name,
               username: Faker::Artist.name
    end

    before do
      user.password = 'Mars123456!'
      user.save
      user.password_reset_token = Box::Encrypting.digest(SecureRandom.urlsafe_base64)
      user.password_reset_token_sent_at = Time.current
    end

    it 'renders the headers' do
      mail = PasswordResetMailer.with(user: user).reset_email.deliver_now

      expect(mail.subject).to eq(I18n.t('password_reset_mailer.reset_email.subject'))

      expect(mail.to).to eq([user.email])

      expect(mail.from).to eq([Rails.application.credentials.dig(:action_mailer, :mail_from)])
    end
  end
end
