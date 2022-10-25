# frozen_string_literal: true

RSpec.describe UserBulkExportJob do
  include ActiveJob::TestHelper

  subject(:job) { described_class.perform_later initiator }

  let(:initiator) { create(:user) }

  after do
    clear_enqueued_jobs
    clear_performed_jobs
  end

  describe '#perform_later' do
    before { ActiveJob::Base.queue_adapter = :test }

    it 'specify that job was enqueued' do
      expect do
        described_class.perform_later(initiator)
      end.to have_enqueued_job
    end

    it 'specify that job was enqueued for the correct date and time' do
      expect do
        described_class.set(wait_until: Date.tomorrow.noon, queue: 'low').perform_later(initiator)
      end.to have_enqueued_job.with(initiator).on_queue('low').at(Date.tomorrow.noon)
    end

    it 'specify that job was enqueued with no wait' do
      expect do
        described_class.set(queue: 'low').perform_later(initiator)
      end.to have_enqueued_job.with(initiator).on_queue('low').at(:no_wait)
    end

    it 'queues the job' do
      expect { job }
        .to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(1)
    end
  end

  it 'queues the job' do
    expect { job }.to have_enqueued_job(described_class)
      .with(initiator)
      .on_queue('default')
  end

  it 'return downloaded archive' do
    stream = {
      id: 9,
      key: 'twfmzruqmql283rm0lfuj4m19rm9',
      filename: 'users.zip',
      content_type: 'application/zip',
      byte_size: 49_427
    }

    allow(UserBulkExportService).to receive(:call).and_return(stream)

    expect(UserBulkExportService.call[:key]).to be_present

    expect(UserBulkExportService.call[:filename]).to be_present

    expect(UserBulkExportService.call).not_to be_nil
  end
end
