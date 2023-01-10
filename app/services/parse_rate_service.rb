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

    @yaml_service.put(:current_rate, rate_value)
  end

  private

  def parse_html
    doc = Nokogiri::HTML(@html)
    doc.css('table.data tbody tr').each do |row|
      row.children.each do |td|
        return row.children[-2].content if td.content == 'Доллар США'
      end
    end

    raise StandardError, 'Parse failed. No needed content.'
  end
end
