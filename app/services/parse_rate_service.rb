# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'

class ParseRateService < ApplicationService
  DEFAULT_URL = 'https://www.cbr.ru/currency_base/daily/'

  def initialize(url = DEFAULT_URL)
    @html = URI.parse(url).open
    @yaml_service = YamlService.new

    super
  end

  def update_rate
    rate_value = parse_html

    @yaml_service.put(rate_value)
  end

  private

  def parse_html
    doc = Nokogiri::HTML(@html)
    new_array = []

    doc.css('table.data tbody tr').each do |row|
      result = row.children.each_with_object({}) do |td, hash|
        next unless td.content == 'Доллар США' || td.content == 'Евро'

        hash[td.content.to_s] = row.children[-2].content.to_s
      end

      new_array << result unless result.empty?
    end

    raise StandardError, 'Parse failed. No needed content.' if new_array.empty?

    new_array
  end
end
