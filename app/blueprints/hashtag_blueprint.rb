# frozen_string_literal: true

# сериализатор
class HashtagBlueprint < Blueprinter::Base
  # для каждого тега берем его id
  identifier :id
  # название поля :text
  fields :text
end
