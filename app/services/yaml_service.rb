# frozen_string_literal: true

require 'yaml'

class YamlService < ApplicationService
  DEFAULT_FILE_PATH = "#{Rails.root}/app/services/data/data.yml".freeze

  def initialize(path_to_file = DEFAULT_FILE_PATH)
    @path_to_file = path_to_file
    reload

    super
  end

  def get(key)
    reload
    @data[key.to_s]
  end

  def put(key, value)
    @data[key.to_s] = value
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
