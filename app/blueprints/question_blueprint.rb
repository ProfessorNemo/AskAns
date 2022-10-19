# frozen_string_literal: true

# сериализатор
class QuestionBlueprint < Blueprinter::Base
  # для каждого вопроса берем его id
  identifier :id

  fields :text, :answer

  view :normal do
    fields :author
    association :author, blueprint: UserBlueprint
    association :user, blueprint: UserBlueprint
  end
end
