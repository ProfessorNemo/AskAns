# frozen_string_literal: true

module Username
  extend ActiveSupport::Concern
  NIK = %w[evil god devil].map(&:downcase).freeze

  included do
    validates :username, presence: true, length: { in: 1..40 },
                         format: { with: /\A[0-9a-zA-Z\-_]+\z/,
                                   message: :username_message }

    validate :check_nik, if: :should_validate

    validate :register

    private

    def check_nik
      errors.add(:username, :username_error, username: username) if NIK.any?(register)
      # errors.add :base, "This user is #{username}" if NIK.any?(username)
    end

    def register
      return unless should_validate

      username.downcase
    end

    def should_validate
      new_record? || present?
    end
  end
end
