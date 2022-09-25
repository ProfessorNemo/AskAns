# frozen_string_literal: true

class QuestionPolicy < ApplicationPolicy
  # Кто может создавать новые вопросы? Все, кроме заблок. юзера
  def create?
    !user.blocked_status?
  end

  # Кто может редактировать вопросы?
  # Юзер с ролью администратора, модератора, автор профиля или автор вопроса. Вопрос
  # передается в методе "authorize"
  def update?
    return if user.blocked_status? || user.guest? || user.id != record.user_id

    user.admin_role? || user.moderator_role? || user.author?(record) || user.id == record.user_id
  end

  def destroy?
    return if user.blocked_status? || user.guest?

    user.admin_role? || user.author?(record) || user.id == record.user_id
  end

  # Кто может просматривать список всех вопросов?
  # Это могут делать все, поэтому "true". Разрешим всем гостям.
  def index?
    true
  end

  # Кто может открывать конкретный вопрос? Это могут делать все,
  # поэтому "true". Разрешим всем гостям.
  def show?
    true
  end
end
