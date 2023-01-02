# frozen_string_literal: true

RSpec.describe AlbumPolicy, type: :policy do
  subject { described_class.new(user, album) }

  let!(:album) { create(:album) }

  context 'being a visitor' do
    let(:user) { nil }

    it { is_expected.to forbid_action(:show) }
    it { is_expected.to forbid_action(:create) }
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
    let(:user) { build(:admin) }

    before do
      user.name = 'Traveler'
      user.email = 'suspense@mail.com'
      user.username = 'traveler'
      user.id = 2
      user.old_password = user.password
      user.save!
    end

    it { is_expected.to permit_actions(%i[show create]) }
    it { is_expected.to forbid_actions(%i[update destroy]) }
  end

  context 'being an blocked' do
    let(:user) { build(:blocked) }

    before do
      user.name = 'Traveler'
      user.email = 'suspense@mail.com'
      user.username = 'traveler'
      user.id = 2
      user.old_password = user.password
      user.save!
    end

    it { is_expected.to permit_actions(%i[show create]) }
    it { is_expected.to forbid_actions(%i[update destroy]) }
  end
end
