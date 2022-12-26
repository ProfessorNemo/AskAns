# frozen_string_literal: true

class AlbumsController < ApplicationController
  before_action :set_user, only: %i[index new create]
  before_action :authorize_user, only: %i[new create]
  before_action :set_album, only: :show
  before_action :set_current_user_album, only: %i[edit update destroy]

  before_action :authorize_album!, except: %i[delete_album_photos]
  after_action :verify_authorized, except: %i[delete_album_photos]

  def index
    @albums = @user.albums
  end

  def show; end

  def new
    @album = @user.albums.build
  end

  def edit; end

  def create
    @album = @user.albums.build album_params
    @album.user = current_user

    if @album.save
      redirect_to user_albums_path, notice: t('.notice')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @album.update album_params
      redirect_to user_albums_path, notice: t('.notice')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @album.destroy

    redirect_to user_albums_path, notice: t('.notice')
  end

  def delete_album_photos
    attachment = ActiveStorage::Attachment.find(params[:id])

    respond_to do |format|
      format.html do
        if attachment.record.user == current_user
          attachment.purge
          flash[:success] = t('.success')
          redirect_back(fallback_location: user_albums_path)
        else
          redirect_to root_path, notice: t('.notice')
        end
      end
    end
  end


  private

  def set_album
    @album = Album.includes([:user]).find(params[:id])
  end

  def set_user
    @user = User.find_by(id: params[:user_id])
  end

  def set_current_user_album
    @album = current_user.albums.find(params[:id])
  end

  def authorize_user
    reject_user unless @user.id == current_user.id
  end

  def album_params
    params.require(:album).permit(:title, :description, album_photos: [])
  end

  def authorize_album!
    authorize(@album || Album)
  end
end
