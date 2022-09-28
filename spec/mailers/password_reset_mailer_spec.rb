# frozen_string_literal: true

RSpec.describe PasswordResetMailer, type: :mailer do
  describe 'reset_created' do
    let(:user) { create(:another_user) }

    let(:mail) { described_class.with(user: user).reset_email.deliver_later }

    before do
      user.set_password_reset_token
    end

    it 'renders the headers' do
      expect(mail.subject).to eq(I18n.t('password_reset_mailer.reset_email.subject'))

      expect(mail.to).to eq([user.email])

      expect(mail.from).to eq([Rails.application.credentials.dig(:action_mailer, :mail_from)])
    end
  end
end
