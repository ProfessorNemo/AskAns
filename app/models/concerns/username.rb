# frozen_string_literal: true

module Username
  extend ActiveSupport::Concern
  NIK = %w[Evil evil god God].freeze

  included do
    validates :username, presence: true, length: { in: 1..40 },
                         uniqueness: { case_sensitive: false },
                         format: { with: /\A[0-9a-zA-Z\-_]+\z/,
                                   message: :username_message }

    validate :check_nik

    before_save :register

    private

    def check_nik
      errors.add(:username, :username_error, username: username) if NIK.any?(username)
      # errors.add :base, "This user is #{username}" if NIK.any?(username)
    end

    def register
      username.downcase!
    end
  end
end
