# frozen_string_literal: true

RSpec.describe QuestionPolicy, type: :policy do
  subject { described_class.new(user, question) }

  let(:question) { Question.create text: 'Are you going to fuck?', user_id: 1 }

  context 'being a visitor' do
    let(:user) { nil }

    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:create) }
    it { is_expected.to permit_action(:index) }
    it { is_expected.to forbid_action(:destroy) }
    it { is_expected.to forbid_action(:update) }
  end

  context 'being an user-basic' do
    let(:user) { create(:another_user, id: 2) }

    it { is_expected.to permit_actions(%i[show create]) }

    it { is_expected.to forbid_action(:destroy) }

    it { is_expected.to forbid_action(:update) }
  end

  context 'being an user-administrator' do
    let(:user) { create(:admin, id: 1) }

    it { is_expected.to permit_actions(%i[show destroy create update]) }
  end

  context 'being an blocked' do
    let(:user) { create(:blocked) }

    it { is_expected.to forbid_actions(%i[create update destroy]) }
  end
end
