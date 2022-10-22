# frozen_string_literal: true

class QuestionSave
  def self.call(question)
    new(question).call
  end

  def call
    return if question.author_id.nil?

    question.transaction do
      question.save

      question.send(:create_hashtags)
    end
  end

  private

  attr_reader :question

  def initialize(question)
    @question = question
  end
end
