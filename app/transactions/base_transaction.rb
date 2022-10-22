# frozen_string_literal: true

class BaseTransaction
  include Dry::Transaction

  def self.call(...)
    new.call(...)
  end
end
