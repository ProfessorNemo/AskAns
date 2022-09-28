# frozen_string_literal: true

RSpec.describe Admin::UserPolicy, type: :policy do
  subject { described_class.new(user, user) }

  let(:user) { create(:another_user) }

  context 'user registers' do
    let(:user) { create(:admin) }

    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:create) }
    it { is_expected.to permit_action(:index) }
    it { is_expected.to permit_action(:destroy) }
    it { is_expected.to permit_action(:update) }
  end
end
