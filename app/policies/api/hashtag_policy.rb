# frozen_string_literal: true

# Любые действия может выполнять только админ

module Api
  class HashtagPolicy < ApplicationPolicy
    def index?
      user.admin_role?
    end
  end
end
