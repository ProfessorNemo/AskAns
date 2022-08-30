# frozen_string_literal: true

require_relative 'internals'

module UsersHelper
  def inclination(amount, *words)
    prefix =
      if (11..14).cover?(amount % 100)
        words.empty? ? Box.many : " #{words[2]}"

      elsif amount % 10 == 1
        words.empty? ? Box.one : " #{words[0]}"

      elsif (2..4).cover?(amount % 10)
        words.empty? ? Box.several : " #{words[1]}"

      else
        words.empty? ? Box.many : " #{words[2]}"

      end

    amount.to_s + prefix
  end
end
