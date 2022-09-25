# frozen_string_literal: true

class GuestUser
  # это гость

  def guest?
    true
  end

  # гость не может редактировать и удалять свои вопросы.
  # Поскольку все гости есть nil и не имеют уникального индекса
  # то метод будет выдавать false
  def author?(_)
    false
  end

  def method_missing(name, *args, &block)
    # возвращает false, если название вызванного метода заканчивается на "role", т.е.
    # когда пытаемся считать роль, а у гостя нет никакой роли
    return false if name.to_s.end_with?('_role?', '_status?', 'id')

    # если м-д заканчивается на что-то другое и мы не знаем что это за м-д
    super(name, *args, &block)
  end

  def respond_to_missing?(name, include_private)
    # мы можем отвечать (образец класса отвечает) на м-д только если, если
    # название вызванного метода заканчивается на "role"
    return true if name.to_s.end_with?('_role?', '_status?', 'id')

    super(name, include_private)
  end
end

# method_missing - м-д, который автоматически вызывается в тех случаях, когда относительно
# образца класса был вызван несуществующий метод
