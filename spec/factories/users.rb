# frozen_string_literal: true

FactoryBot.define do
  factory :user, aliases: [:author] do
    name { 'Suspense' }
    sequence :email do |n|
      "suspense#{n}@gmail.com"
    end
    username { 'strangeness' }
    password { 'Omega123456!' }
    role { 'basic' }
    status { 'activated' }
    sequence(:id) { |n| n }

    factory :user_with_incorrect_email do
      email { 'test' }
    end

    factory :user_with_incorrect_username do
      username { 'evil' }
    end

    trait :admin do
      role { 'admin' }
    end

    trait :blocked do
      status { 'blocked' }
    end

    trait :id do
      id { 1 }
    end

    trait :unknown_id do
      name { Faker::Name.middle_name }
      password { 'Omega123456!' }
      username { Faker::Internet.username(specifier: 'Nancy') }
      email { Faker::Internet.email }
      role { 'basic' }
      status { 'activated' }
    end

    factory :another_user, traits: [:unknown_id]
    factory :admin, traits: [:admin]
    factory :blocked, traits: [:blocked]
    factory :id, traits: [:id]
  end
end

# В фэктори описываем те данные, которые тестируем
# sequence (последовательность) - для создания уникальных юзеров с уникальным email

# trait - название поля,  :admin - любое имя
# trait :admin do
#   role { 'admin' }
# end
# Затем создаю на основе текущего юзера нового (новую фэктори),
# которая называется "admin". У этого "admin" будут такие же поля,
# как у "user", но плюс еще поле "role { 'admin' }". Таким образом можно
# настраивать, будет юзер админом или нет. А у заблокированного юзера
# добавлено поле, помеченное трейтом "traits: [:blocked]"

# let(:user) { create(:user) } - взять из фэктори юзера с названием ":user",
# создать в тестовой бд и поместить его в переменную ":user". Или так:
# let(:user) { create(:admin) } - создание юзера с дополнительным полем "admin: true"

# Если let(:user) { build(:user) } - у юзера не будет created_at, updated_at, id...

# attrs = attributes_for(:user) - вытащить аттрибуты для фэктори (хэш из полей name, email и т.д.)

# stub = build_stubbed(:user) - создается фейковое значение id для юзера, но по факту в бд ничего
# не сохраняем, но делаем вид что сохраняем
