# frozen_string_literal: true

# сериализатор
class QuestionBlueprint < Blueprinter::Base
  # для каждого вопроса берем его id
  identifier :id

  view :normal do
    fields :text, :answer
    association :author, blueprint: UserBlueprint
    association :user, blueprint: UserBlueprint
  end
end
