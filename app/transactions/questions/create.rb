# frozen_string_literal: true

module Questions
  class Create < BaseTransaction
    step :build_model
    step :validation
    step :persistence

    def build_model(input)
      question = Question.new(author: input[:current_user], **input[:params])

      Success(input.merge(question: question))
    end

    def validation(input)
      if (input[:current_user].present? || verify_recaptcha(model: input[:question])) && input[:question].save
        Success(input)
      else
        Failure(input)
      end
    end

    def persistence(input)
      QuestionSave.call(input[:question])
      # input[:question].send(:create_hashtags)

      Success(input)
    end
  end
end

# "input" - хэш - опрокидываем из одного метода в другой.К примеру, в "check_recaptcha"
# input уже будет уже таким: "input.merge(question: question)" и т.д.

# "**input[:params]" - двойной splat-оператор **, чтобы развернуть хэш, т.е. все
# параметры в "question_params". (операция выпрямления)
# "author: input[:current_user], **input[:params]" - один единый хэш
