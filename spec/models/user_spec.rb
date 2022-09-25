# frozen_string_literal: true

RSpec.shared_examples_for 'a user' do
  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:role) }
  it { is_expected.to respond_to(:email) }
  it { is_expected.to respond_to(:username) }
  it { is_expected.to respond_to(:password) }
end

RSpec.describe User, type: :model do
  it_behaves_like 'a user'
  context 'validates' do
    it 'is valid' do
      user = build(:user)
      expect(user).to be_valid
    end

    it 'email is true and users save to base' do
      user = build(:user)
      expect(user.email).to be_truthy
      # сохраняется объект без ошибок
      expect { user.save }.not_to raise_error
    end

    it 'email is required / email not valid' do
      user = build(:user, email: 'javascript@gmail.com')
      expect(user).not_to be_valid
    end

    it 'name can be omitted / name valid' do
      user = build(:user, name: nil)
      expect(user).to be_valid
    end

    it 'password cannot be empty' do
      user = build(:user, password: nil)
      expect(user).not_to be_valid
    end

    specify '#password_digest' do
      user = build(:user, password: 'Fake123!')
      expect(user.password).to eq('Fake123!')
      expect(user.password_digest).to be_a(String)
    end

    it 'User name is Suspense and basic' do
      user = build(:user)
      expect(user.name).to eq('Suspense')
      expect(user.role).to eq('basic')
    end

    it 'email incorrect' do
      user = build(:user_with_incorrect_email)
      expect(user).not_to be_valid
    end

    it 'username incorrect' do
      user = build(:user_with_incorrect_username)
      expect(user).not_to be_valid
    end

    it 'user is not empty' do
      user = attributes_for(:user)
      expect(user).not_to be_empty
    end
  end

  context 'continuation of validations' do

    it 'validates_user_admin' do
      user = build_stubbed(:admin)
      expect(user.role).to eq('admin')
      expect(user.id).to be_truthy
    end

    it 'validates_user_blocked' do
      user = build_stubbed(:blocked)
      expect(user.status).to eq('blocked')
    end
  end
end
