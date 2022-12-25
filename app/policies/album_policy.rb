# frozen_string_literal: true

class AlbumPolicy < ApplicationPolicy
  # Кто может создавать новые альбомы?
  def create?
    return if user.guest?

    user.present? || record.where(user: user).take.user == user
  end

  def update?
    destroy?
  end

  def destroy?
    return if user.guest?

    record.author_album == user
  end

  # Кто может просматривать список всех альбомов?
  # Это могут делать все, поэтому "true". Разрешим всем гостям.
  def index?
    true
  end

  # Кто может открывать конкретный вопрос? Это могут делать все,
  # поэтому "true". Разрешим всем.
  def show?
    return if user.guest?

    true
  end
end
