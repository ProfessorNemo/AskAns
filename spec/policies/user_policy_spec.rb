# frozen_string_literal: true

RSpec.describe UserPolicy, type: :policy do
  subject { described_class.new(user, user) }

  let(:user) { create(:another_user) }

  context 'user registers' do
    let(:user) { nil }

    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:create) }
    it { is_expected.to permit_action(:index) }
    it { is_expected.to forbid_action(:destroy) }
    it { is_expected.to forbid_action(:update) }
  end
end
