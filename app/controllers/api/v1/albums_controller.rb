# frozen_string_literal: true

module API
  module V1
    class AlbumsController < RootController
      def index
        @user = User.where(username: params[:user_username]).take
        @albums = @user.albums
        render json: AlbumBlueprint.render(@albums)
      end
    end
  end
end
