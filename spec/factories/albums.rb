# frozen_string_literal: true

FactoryBot.define do
  factory :album do

    title { 'Maldives' }
    description { 'Diving with sharks' }
    association :user

    trait :with_image do
      after :build do |album|
        file_name = 'image.jpeg'
        file_path = Rails.root.join('spec', 'support', file_name)
        album.album_photos.attach(io: File.open(file_path),
                                  filename: file_name,
                                  content_type: 'image/jpeg')
      end
    end
  end
end
