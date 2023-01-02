# frozen_string_literal: true

RSpec.describe AlertUserPhotoAlbumJob do
  include ActiveJob::TestHelper

  subject(:job) { described_class.perform_later initiator, album, n_add }

  let(:album) { create(:album, :with_image) }
  let(:initiator) { album.user }
  let(:n_add) { 1 }

  after do
    clear_enqueued_jobs
    clear_performed_jobs
  end

  describe '#perform_later' do
    before { ActiveJob::Base.queue_adapter = :test }

    specify '#perform' do
      expect(described_class).to respond_to(:perform_later)
    end

    it 'specify that job was enqueued' do
      expect do
        described_class.perform_later(initiator, album, n_add)
      end.to have_enqueued_job.at_least(2)
    end

    it 'specify that job was enqueued with no wait' do
      expect do
        described_class.set(queue: 'low').perform_later(initiator, album, n_add)
      end.to have_enqueued_job.with(initiator, album, n_add).on_queue('low').at(:no_wait)
    end

    it 'queues the job' do
      expect { job }
        .to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(2)
    end
  end

  it 'queues the job' do
    expect { job }.to have_enqueued_job(described_class)
      .with(initiator, album, n_add)
      .on_queue('upload_photo')
  end

  it { is_expected.to be_processed_in :upload_photo }
  it { is_expected.to be_retryable 1 }

  it do
    build_list(:user, 10) do |user, i|
      user.name = "Traveler#{i}"
      user.email = "suspense#{i}@mail.com"
      user.username = "traveler#{i}"
      user.id = (i + 2)
      user.old_password = user.password
      user.save!
    end

    expect do
      described_class.perform_later(initiator, album, n_add)
    end.to have_enqueued_job.on_queue('upload_photo').exactly(:once)
  end
end
