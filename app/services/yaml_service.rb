# frozen_string_literal: true

require 'yaml'

class YamlService < ApplicationService
  DEFAULT_FILE_PATH = "#{Rails.root}/app/services/data/data.yml".freeze

  def initialize(path_to_file = DEFAULT_FILE_PATH)
    @path_to_file = path_to_file
    reload

    super
  end

  def get
    reload

    @data.invert.keys
  end

  def put(rate_value)
    dollar = rate_value[0].invert.keys[0]
    euro = rate_value[1].invert.keys[0]

    @data[@data.keys[0]] = dollar
    @data[@data.keys[1]] = euro

    save
  end

  private

  def save
    File.write(@path_to_file, @data.to_yaml)
  end

  def reload
    @data = YAML.safe_load(File.read(@path_to_file))
  end
end
