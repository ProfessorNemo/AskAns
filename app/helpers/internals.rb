# frozen_string_literal: true

Box.internals do |internal|
  # вот сюда (в internal) передаем сам модуль "Box" и для модуля мы
  # задаем аттрибуты
  internal.one = 'nan'

  internal.several = 'nan'

  internal.many = 'nan'
end
