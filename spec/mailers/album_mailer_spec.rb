# frozen_string_literal: true

RSpec.describe AlbumMailer do
  let!(:album) { create(:album, :with_image) }
  let(:n) { album.album_photos.count }
  let(:user) { album.user }
  let(:photos) { album.album_photos.order(created_at: :desc).limit(n) }
  let(:mail) { described_class.photo(album, user.email, photos).deliver_now }

  describe 'reset_created' do
    it 'renders the headers' do
      expect(mail.subject).to eq(I18n.t('album_mailer.photo.subject',
                                        user: album.user.name,
                                        album: album.title))
    end

    it 'sending email' do
      expect do
        described_class.photo(album, user.email, photos).deliver_now
      end.to change { ActionMailer::Base.deliveries.count }.by(1)
    end

    it 'recipient\'s mailing address' do
      expect(mail.to).to eq([user.email])
    end

    it 'sender\'s mailing address' do
      expect(mail.from).to eq([ENV.fetch('MAILJET_SENDER', nil)])
    end

    it 'sent email is a string' do
      expect(mail.body.encoded).to be_a(String)
    end

    it 'the letter was actually sent' do
      user = build_stubbed(:user)
      described_class.photo(album, user.email, photos).deliver_now
      expect(user).to have_received_email
    end

    it 'the user got the expected title' do
      user = build_stubbed(:user)
      described_class.photo(album, user.email, photos).deliver_now
      expect(user)
        .to have_received_email(subject: I18n.t('album_mailer.photo.subject',
                                                user: album.user.name,
                                                album: album.title))
    end
  end

  context 'when multiple users' do
    let(:stubbed_users) { build_stubbed_list(:user, 10) }
    let(:all_emails) { stubbed_users.pluck(:email) }
    let(:letters) { described_class.photo(album, all_emails, photos).deliver_now }

    it 'one email was sent' do
      expect { letters }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end

    it 'recipient\'s mailing address' do
      expect(letters.to == all_emails).to be(true)
    end
  end
end
