# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    author
    text do
      'О сколько нам открытий чудных
    Готовят просвещенья дух
    И опыт, сын ошибок трудных,
    И гений, парадоксов друг,
    И случай, бог изобретатель.'
    end

    trait :user_id do
      user_id { 1 }
      author_id { 1 }
    end

    trait :author_id do
      user_id { 1 }
      author_id { nil }
    end

    trait :many do
      quest =
        30.times do
          Faker::Hipster.sentence(word_count: 5)
        end
      sequence(:text) do |n|
        quest[n]
      end
      user_id { 1 }
      author_id { 1 }
    end

    factory :question_id, traits: [:user_id]

    factory :guest, traits: [:author_id]

    factory :many_questions, traits: [:many]

    association :user, factory: :user, email: 'suspense1@gmail.com', strategy: :build
  end
end
