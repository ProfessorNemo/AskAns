# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  # Кто может создать юзера или зарегистрироваться
  def create?
    user.guest? && !user.blocked_status?
  end

  # Модифицировать свой профиль может только владелец профиля, т.е.
  # текущий пользователь есть юзер, которого надо отредактировать
  def update?
    record == user
  end

  # кто может просматривать список всех юзеров (все)
  def index?
    true
  end

  # конкретного юзера (учетную запись) может просматривать кто угодно
  # Хотья пока метода "show" нет в "users_controller"
  def show?
    true
  end

  # никто не может из неадминского контроллера. Но при желании можно сделать так,
  # чтоб юзеры смогли удалять свои учетные записи
  def destroy?
    false
  end
end
