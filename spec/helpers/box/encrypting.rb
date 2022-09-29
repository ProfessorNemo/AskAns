# frozen_string_literal: true

module Box
  module Encrypting
    def self.digest(string)
      cost = if ActiveModel::SecurePassword
                .min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create(string, cost: cost)
    end
  end
end
