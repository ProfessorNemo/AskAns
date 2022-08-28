# frozen_string_literal: true

Box.internals do |internal|
  # вот сюда (в internal) передаем сам модуль "Box" и для модуля мы
  # задаем аттрибуты
  internal.one = 'ресурс'

  internal.several = 'ресурса'

  internal.many = 'ресурсов'
end
