# frozen_string_literal: true

# Любые действия может выполнять только админ

module Admin
  class UserPolicy < ApplicationPolicy
    def create?
      user.admin_role?
    end

    def update?
      user.admin_role?
    end

    def index?
      user.admin_role?
    end

    def show?
      user.admin_role?
    end

    def destroy?
      user.admin_role?
    end

    def upvote?
      user.admin_role?
    end

    def downvote?
      user.admin_role?
    end
  end
end
