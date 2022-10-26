# frozen_string_literal: true

RSpec.describe PasswordResetsController do
  describe 'reset_created' do
    let(:user) do
      User.create email: Faker::Internet.email,
                  name: Faker::Name.name,
                  username: 'Artist',
                  password: 'Mars123456!',
                  password_confirmation: 'Mars123456!'
    end

    before do
      user.password_reset_token = Box::Encrypting.digest(SecureRandom.urlsafe_base64)
      user.password_reset_token_sent_at = Time.current
    end

    after do
      User.destroy_all
    end

    it 'renders the headers' do
      mail = PasswordResetMailer.with(user: user).reset_email.deliver_now

      expect(mail.subject).to eq(I18n.t('password_reset_mailer.reset_email.subject'))

      expect(mail.to).to eq([user.email])

      expect(mail.from).to eq([ENV.fetch('MAILJET_SENDER', nil)])
    end

    it 'redirects to new_session_path' do
      post :create, params: { email: user.email }

      expect(response).to redirect_to(new_session_path)
      expect(flash[:success]).not_to be_nil
    end

    it 'redirects to new_session_path if update password' do
      patch :update

      expect(response).to redirect_to(new_session_path)
      expect(response).to have_http_status(:found)
      expect(flash[:success]).to be_nil
    end
  end
end
