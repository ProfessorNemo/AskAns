# frozen_string_literal: true

RSpec.shared_examples_for 'a album' do
  it { is_expected.to respond_to(:title, :description) }
end

RSpec.describe Album do
  it 'has a valid factory' do
    album = build(:album)
    expect(album).to be_valid

    album = build(:album, :with_image)
    expect(album).to be_valid
    expect(album.album_photos).to be_attached

    album.save!
    expect(album.album_photos).to be_attached

    expect(album).to respond_to(:album_photos, :image_urls, :image_count)
  end

  it 'must have user' do
    album = build(:album, user: nil)
    expect(album).not_to be_valid
  end

  it 'album may be empty' do
    album = build(:album, album_photos: nil)
    expect(album).to be_valid
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user).class_name('User') }
  end

  context 'validations check' do
    it { is_expected.to validate_presence_of :title }
    it { is_expected.to validate_presence_of :description }
  end

  it 'album is not empty' do
    album = attributes_for(:album, :with_image)
    expect(album).not_to be_empty
  end

  describe 'relations' do
    it { is_expected.to have_many_attached(:album_photos) }
  end

  describe '#album_photos' do
    subject { create(:album, :with_image).album_photos }

    it { is_expected.to be_an_instance_of(ActiveStorage::Attached::Many) }
  end
end
