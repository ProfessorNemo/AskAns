# frozen_string_literal: true

RSpec.configure { |c| c.before { expect(controller).not_to be_nil } }

RSpec.describe UsersController, type: :controller do
  describe '#index' do
    let(:user) { create(:user) }

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

  context 'when the user was saved' do
    # before { create_list(:user, 30) }
    describe '#create' do
      before { User.delete_all }
      after { User.delete_all }

      it 'redirects to root_path' do
        post :create, params: { user: { email: Faker::Internet.email, password: 'Omega123456!',
                                        password_confirmation: 'Omega123456!', name: Faker::Name.middle_name,
                                        username: Faker::Internet.username(specifier: 'Nancy'),
                                        role: 'basic', status: 'activated' } }

        user = assigns(:user)
        expect(user.persisted?).to be(true)
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(root_path)
        expect(flash[:success]).not_to be_nil
      end

      specify '#destroy' do
        user = build(:user)

        expect(user.valid?).to be(true)

        user.save

        expect(user.persisted?).to be(true)

        delete :destroy, params: { 'id' => user.id }
        User.where(id: user.id).destroy_all
        user = assigns(:user)

        expect(User.pluck(:id).empty?).to be(true)
        expect(user.present?).to be(false)
        expect(response).to redirect_to(root_path)
        expect(response).to have_http_status(:found)
        expect(flash[:success]).to be_nil
      end

      specify '#show' do
        user = create(:user)
        get :show, params: { 'id' => user.id }
        user = assigns(:user)

        expect(user.present?).to be(true)
        expect(response).to render_template('show')
        expect(response).to have_http_status(:ok)
      end

      describe '#update' do
        let(:user) { build(:user) }

        before do
          user.old_password = user.password
          user.save
        end

        it 'redirect_to user_path(@user)' do
          expect(user.persisted?).to be(true)

          user.username = 'alien'
          put :update, params: { 'id' => user.id, user: user.attributes }
          user.save

          expect(user.updated_at != user.created_at).to be(true)
          expect(user.present?).to be(true)
          expect(response).to have_http_status(:found)
        end
      end
    end
  end
end
