# frozen_string_literal: true

# сериализатор
class AlbumBlueprint < Blueprinter::Base
  identifier :id

  view :normal do
    field :title
    field :image_count
    field :description
    field :image_urls
    field :created_at, datetime_format: '%m/%d/%Y'
    field :updated_at, datetime_format: '%m/%d/%Y'
    association :user, blueprint: UserBlueprint
  end
end
