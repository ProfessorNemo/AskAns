# frozen_string_literal: true

module Exchange
  class Client
    include Exchange::Rest

    attr_reader :token

    def initialize(token = [])
      @token = token
      @token.empty? ? @token = remember_token : @token
    end

    def remember_token
      digest(SecureRandom.urlsafe_base64)
    end

    def digest(string)
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
