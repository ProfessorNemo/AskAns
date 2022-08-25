# frozen_string_literal: true

module Box
  # Для всего модуля задаем его аттрибуты
  class << self
    # Объявление аттрибута, который будет доступен для записи и для чтения
    attr_accessor :many, :one, :several

    # метод передает в принятый блок "self", а "self" указывает на "Box"
    def internals
      yield self
    end
  end
end
