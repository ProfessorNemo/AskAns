# frozen_string_literal: true

RSpec.configure { |c| c.before { expect(controller).not_to be_nil } }

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user) }
  # before { create_list(:user, 30) }

  describe '#index' do
    it 'render :index' do
      get :index

      expect(user.present?).to be(true)
      expect(response).to render_template(:index)
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#new' do
    it 'render :new' do
      new_user = build :user
      get :new, params: {
        user: {
          id: new_user.id,
          username: 'nemo',
          email: new_user.email
        }
      }
      expect(response).to render_template(:new)
    end
  end

  describe '#create' do
    it 'redirects to root_path' do
      post :create, params: { user: { email: Faker::Internet.email, password: 'Omega123456!',
                                      password_confirmation: 'Omega123456!', name: Faker::Name.middle_name,
                                      username: Faker::Internet.username(specifier: 'Nancy'),
                                      role: 'basic', status: 'activated' } }

      # user = assigns(:user)
      expect(user.persisted?).to be(true)
      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(root_path)
      expect(flash[:success]).not_to be_nil
    end
  end

  describe '#destroy' do
    it 'redirects to root_path' do
      expect(user.persisted?).to be(true)

      delete :destroy, params: { id: user.id }
      user = assigns(:user)

      expect(user.present?).to be(false)
      expect(response).to redirect_to(root_path)
      expect(response).to have_http_status(:found)
      expect(flash[:warning]).not_to be_nil
    end
  end

  describe '#show' do
    it 'render template \'show\'' do
      get :show, params: { 'id' => user.id }
      user = assigns(:user)

      expect(user.present?).to be(true)
      expect(response).to render_template('show')
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#update' do
    before do
      user.remember_me
      cookies.encrypted.permanent[:remember_token] = user.remember_token
      cookies.encrypted.permanent[:user_id] = user.id
    end

    it 'redirect_to user_path(user)' do
      expect(user.persisted?).to be(true)
      expect(user.id).not_to be_nil

      put :update, params: { id: user.id, user: { id: user.id, username: 'alien' } }
      user = assigns(:user)

      expect(user.updated_at != user.created_at).to be(true)
      expect(user.present?).to be(true)
      expect(response).to have_http_status(:found)
      expect(flash[:success]).not_to be_nil
    end
  end
end
