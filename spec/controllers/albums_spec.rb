# frozen_string_literal: true

RSpec.configure { |c| c.before { expect(controller).not_to be_nil } }

RSpec.describe AlbumsController do
  describe 'GET index' do
    it 'has a 200 status code' do
      album = build(:album)
      album.save
      user = album.user

      get :index, params:
      { 'controller' => 'albums', 'action' => 'index',
        'locale' => 'ru', 'user_id' => user.id }

      expect(response).to have_http_status(:ok)
      expect(response).to render_template('index')
      expect(response.body).to eq ''

      albums = assigns(:albums)
      expect(albums).not_to be_nil
      expect(albums.count).to eq(1)
      expect(albums.first.user.id).to eq(user.id)
      expect(albums.first.title).to eq('Maldives')
    end
  end

  describe 'routing' do
    let(:album) { build(:album) }
    let(:user) { album.user }

    before do
      album.save
    end

    it 'routes GET /ru/users/user_id/albums to AlbumsController#index' do
      expect(get: "/ru/users/#{user.id}/albums")
        .to route_to(controller: 'albums', action: 'index', locale: 'ru', user_id: user.id.to_s)
    end

    it 'routes POST /ru/users/user_id/albums to AlbumsController#create' do
      expect(post: "/ru/users/#{user.id}/albums")
        .to route_to(controller: 'albums', action: 'create', locale: 'ru', user_id: user.id.to_s)
    end

    it 'routes PATCH /ru/users/user_id/albums/id to AlbumsController#update' do
      expect(patch: "/ru/users/#{user.id}/albums/#{album.id}")
        .to route_to(controller: 'albums',
                     action: 'update',
                     locale: 'ru',
                     user_id: user.id.to_s,
                     id: album.id.to_s)
    end

    it 'routes DELETE /ru/users/user_id/albums/id to AlbumsController#destroy' do
      expect(delete: "/ru/users/#{user.id}/albums/#{album.id}")
        .to route_to(controller: 'albums',
                     action: 'destroy',
                     locale: 'ru',
                     user_id: user.id.to_s,
                     id: album.id.to_s)
    end

    it 'routes DELETE /ru/users/user_id/albums/id/delete_album_photos
         to AlbumsController#delete_album_photos' do
      expect(delete: "/ru/users/#{user.id}/albums/#{album.id}/delete_album_photos")
        .to route_to(controller: 'albums',
                     action: 'delete_album_photos',
                     locale: 'ru',
                     user_id: user.id.to_s,
                     id: album.id.to_s)
    end
  end

  describe '#create' do
    let(:user) { build(:user) }

    before do
      user.save
      user.remember_me
      cookies.encrypted.permanent[:remember_token] = user.remember_token
      cookies.encrypted.permanent[:user_id] = user.id
    end

    it 'has a 300 status code / no photo upload' do
      album = user.albums.build(title: 'St. Petersburg',
                                description: 'Long walk',
                                notifications: 'false')

      post :create, params: { 'controller' => 'albums',
                              'action' => 'create',
                              'locale' => 'ru',
                              'user_id' => user.id,
                              'success' => 'true',
                              'album' => { 'title' => album.title,
                                           'description' => album.description,
                                           'notifications' => '0' } }

      album = assigns(:album)

      expect(album.persisted?).to be(true)
      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(user_albums_path(user))
      expect(flash[:notice]).not_to be_nil
    end

    it 'has a 300 status code / with photo upload' do
      file_name = 'spb_1.jpg'
      file_path = Rails.root.join('spec', 'support', file_name)
      album = user.albums.build(title: 'St. Petersburg',
                                description: 'Long walk',
                                notifications: 'true')
      album.album_photos.attach(io: File.open(file_path),
                                filename: file_name,
                                content_type: 'image/jpeg')
      post :create, params: { 'controller' => 'albums',
                              'action' => 'create',
                              'locale' => 'ru',
                              'user_id' => user.id,
                              'success' => 'true',
                              'album' => { 'title' => album.title,
                                           'description' => album.description,
                                           'notifications' => '0' } }
      album.save
      n = album.album_photos.count
      photos = album.album_photos.order(created_at: :desc).limit(n)

      expect(photos.first.record.title).to eq('St. Petersburg')
      expect(photos.first.blob.filename).to eq('spb_1.jpg')
      expect(album.album_photos.count).to eq(1)
      expect(album.persisted?).to be(true)
      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(user_albums_path(user))
      expect(flash[:notice]).not_to be_nil
    end
  end

  context 'when the destroy and update methods are executed' do
    let(:album) { build(:album, :with_image) }
    let(:user) { album.user }

    before do
      album.save
      user.save
      user.remember_me
      cookies.encrypted.permanent[:remember_token] = user.remember_token
      cookies.encrypted.permanent[:user_id] = user.id
    end

    it 'album updated' do
      expect(album.persisted?).to be(true)
      expect(user.persisted?).to be(true)

      file_name = 'image_2.jpeg'
      file_path = Rails.root.join('spec', 'support', file_name)
      album.album_photos.attach(io: File.open(file_path),
                                filename: file_name,
                                content_type: 'image/jpeg')

      put :update, params: { 'controller' => 'albums',
                             'action' => 'update',
                             'locale' => 'ru',
                             'user_id' => user.id,
                             'id' => album.id,
                             'success' => 'true',
                             'album' => { 'title' => album.title,
                                          'description' => album.description,
                                          'notifications' => '0' } }

      album = assigns(:album)
      n = album.album_photos.count
      photos = album.album_photos.order(created_at: :desc).limit(n)

      expect(photos.second.record.title).to eq('Maldives')
      expect(photos.first.blob.filename).to eq('image_2.jpeg')
      expect(album.updated_at != album.created_at).to be(true)
      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(user_albums_path(user))
      expect(flash[:notice]).not_to be_nil
    end

    it 'album deleted' do
      User.destroy_all
      album = create(:album, :with_image)
      user = album.user
      user_memorization(user)

      # get :destroy, params: { 'controller' => 'albums',
      #                         'action' => 'destroy',
      #                         'locale' => 'ru',
      #                         'user_id' => user.id,
      #                         'id' => album.id }
      # album = assigns(:album)
      #
      # или
      #
      expect do
        get :destroy, params: { 'controller' => 'albums',
                                'action' => 'destroy',
                                'locale' => 'ru',
                                'user_id' => user.id,
                                'id' => album.id }
      end.to change(Album, :count).by(-1)
      album = assigns(:album)

      expect(user.albums.blank?).to be(true)
      expect(album.persisted?).to be(false)
      expect(Album.find_by(id: album.id).present?).to be(false)
      expect(response).to redirect_to(user_albums_path(user))
      expect(response).to have_http_status(:found)
      expect(flash[:notice]).not_to be_nil
    end

    it 'photo deleted' do
      User.destroy_all
      album = create(:album, :with_image)
      user = album.user
      user_memorization(user)

      id_photo = album.album_photos.first.blob_id
      attachment = ActiveStorage::Attachment.find_by(blob_id: id_photo)

      expect(attachment.persisted?).to be(true)
      attachment.purge
      album.reload
      expect(attachment.persisted?).to be(false)

      get :show, params: { 'controller' => 'albums',
                           'action' => 'show',
                           'locale' => 'ru',
                           'user_id' => user.id,
                           'id' => album.id }

      album = assigns(:album)

      expect(album.album_photos.count).to eq(0)
      expect(album.album_photos.blank?).to be(true)
      expect(response).to have_http_status(:ok) # должен быть ответ HTTP 200
      expect(response).to render_template('show') # и отрендерить шаблон show
    end
  end
end

def user_memorization(user)
  user.save
  user.remember_me
  cookies.encrypted.permanent[:remember_token] = user.remember_token
  cookies.encrypted.permanent[:user_id] = user.id
end
