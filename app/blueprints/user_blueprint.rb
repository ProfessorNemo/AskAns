# frozen_string_literal: true

# сериализатор
class UserBlueprint < Blueprinter::Base
  # для каждого юзера берем его id
  identifier :id

  fields :name, :username, :email
end
