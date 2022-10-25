# frozen_string_literal: true

RSpec.describe PasswordResetMailer do
  let(:user) { build_stubbed(:another_user) }
  let(:mail) { described_class.with(user: user).reset_email.deliver_now }

  describe 'reset_created' do
    it 'renders the headers' do
      expect(mail.subject).to eq(I18n.t('password_reset_mailer.reset_email.subject'))
    end

    it 'recipient\'s mailing address' do
      expect(mail.to).to eq([user.email])
    end

    it 'sender\'s mailing address' do
      expect(mail.from).to eq([Rails.application.credentials.dig(:action_mailer, :mail_from)])
    end

    it 'one email was sent' do
      expect { mail }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end

    it 'sent email is a string' do
      expect(mail.body.encoded).to be_a(String)
    end

    it 'the letter was actually sent' do
      user = build_stubbed(:user)
      described_class.with(user: user).reset_email.deliver_now
      expect(user).to have_received_email
    end

    it 'the user got the expected title' do
      user = build_stubbed(:user)
      described_class.with(user: user).reset_email.deliver_now
      expect(user).to have_received_email(subject: I18n.t('password_reset_mailer.reset_email.subject'))
    end
  end
end
