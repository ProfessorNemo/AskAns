# frozen_string_literal: true

module Admin
  module UsersHelper
    def user_roles
      # возьмем ключи ролей { basic: 0, moderator: 1, admin: 2 }
      User.roles.keys.map do |role|
        # текст роли + id роли
        [t(role, scope: 'global.user.roles'), role]
      end
    end

    def user_statuses
      # возьмем ключи ролей { activated: 0, blocked: 1 }
      User.statuses.keys.map do |status|
        # текст статуса + id статуса
        [t(status, scope: 'global.user.statuses'), status]
      end
    end
  end
end