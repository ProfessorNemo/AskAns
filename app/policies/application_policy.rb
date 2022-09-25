# frozen_string_literal: true

# в этот класс при инстанцировании передается текущий юзер (user) и та запись
# по отношению к которой он хочет что-то сделать (record).
# record  м.б. еще и запись для авторизации
class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    # если user = nil, то сделаем гостевого юзера,
    # ибо пользователь в систему не вошел
    @user = user || GuestUser.new
    @record = record
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  # метод "new" зависит от "create"
  def new?
    create?
  end

  def update?
    false
  end

  # метод "edit" зависит от "update"
  def edit?
    update?
  end

  def destroy?
    false
  end

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      raise NotImplementedError, "You must define #resolve in #{self.class}"
    end

    private

    attr_reader :user, :scope
  end
end
