# frozen_string_literal: true

RSpec.describe UserBulkImportJob do
  include ActiveJob::TestHelper

  subject(:job) { described_class.perform_later archive_key, initiator }

  let(:initiator) { create(:user) }

  let(:archive_key) { 'vg6qhpiirgx8fc1szds2z9pf3egx' }

  after do
    clear_enqueued_jobs
    clear_performed_jobs
  end

  describe '#perform_later' do
    before { ActiveJob::Base.queue_adapter = :test }

    it 'specify that job was enqueued' do
      expect do
        described_class.perform_later(initiator, archive_key)
      end.to have_enqueued_job
    end

    it 'specify that job was enqueued for the correct date and time' do
      expect do
        described_class.set(wait_until: Date.tomorrow.noon, queue: 'low').perform_later(initiator, archive_key)
      end.to have_enqueued_job.with(initiator, archive_key).on_queue('low').at(Date.tomorrow.noon)
    end

    it 'specify that job was enqueued with no wait' do
      expect do
        described_class.set(queue: 'low').perform_later(initiator, archive_key)
      end.to have_enqueued_job.with(initiator, archive_key).on_queue('low').at(:no_wait)
    end

    it 'queues the job' do
      expect { job }
        .to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(1)
    end

    it 'handles no results error' do
      allow(UserBulkImportService).to receive(:call).and_return('Импорт пользователей не удался | AskAns')

      expect(UserBulkImportService.call).to eq 'Импорт пользователей не удался | AskAns'
    end
  end

  it 'queues the job' do
    expect { job }.to have_enqueued_job(described_class)
      .with(archive_key, initiator)
      .on_queue('default')
  end
end
