# frozen_string_literal: true

require_relative 'internals'

module UsersHelper
  def questions_count_helper(amount, with_number = nil)
    form =
      if (11..14).cover?(amount % 100)
        Box.many
      elsif amount % 10 == 1
        Box.one
      elsif (2..4).cover?(amount % 10)
        Box.several
      else
        Box.many
      end
    prefix = with_number ? '' : " #{form}"

    amount.to_s + prefix
  end
end
