# frozen_string_literal: true

module Authorship
  extend ActiveSupport::Concern

  included do
    # проверять, что юзер, написавший вопрос является тем
    # юзером, которого мы сюда передали в качестве аргумента. Т.е.
    # написан ли вопрос конкретным юзером
    def authored_by?(user)
      author == user
    end
  end
end
