# frozen_string_literal: true

class ApplicationService
  # классовый метод "call" инстанцирует указанный класс
  # и потом вызывает то действие, который этот класс должен выполнять.
  def self.call(...)
    new(...).call
  end
end
