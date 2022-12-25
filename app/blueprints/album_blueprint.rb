# frozen_string_literal: true

# сериализатор
class AlbumBlueprint < Blueprinter::Base
  identifier :id

  field :title
  field :image_count
  field :description
  field :created_at, datetime_format: '%m/%d/%Y'
  field :updated_at, datetime_format: '%m/%d/%Y'
end
