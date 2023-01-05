# frozen_string_literal: true

module API
  module V1
    class AlbumsController < RootController
      skip_before_action :verify_authenticity_token, only: %i[create update destroy]
      before_action :set_user
      before_action :user_album, only: %i[update destroy]

      def index
        @albums = @user.albums

        success!(AlbumBlueprint.render_as_hash(@albums, view: :normal))
      end

      def show
        @album = Album.includes([:user]).find_by(id: params[:id])

        return fail!('album not found') unless @album

        success!(AlbumBlueprint.render_as_hash(@album, view: :normal))
      end

      def create
        @album = @user.albums.build album_params

        return fail! @album.errors.full_messages unless @album.save

        success!(AlbumBlueprint.render_as_hash(@album, view: :normal))
      end

      def update
        @album = @user.albums.find(params[:id])

        return fail! @album.errors.full_messages unless @album.update album_params

        success!(AlbumBlueprint.render_as_hash(@album, view: :normal))
      end

      def destroy
        return not_found unless @album.destroy

        success!({ album_id: params[:id],
                   message: 'Successfully! Album has been deleted' })
      end

      private

      def set_user
        @user = User.where(username: params[:user_username]).take

        not_found unless @user == current_user
      end

      def user_album
        @album = current_user.albums.find(params[:id])
      end

      def album_params
        params.require(:album).permit(:title, :description, :notifications, album_photos: [])
      end
    end
  end
end
