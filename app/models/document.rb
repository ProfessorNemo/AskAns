# frozen_string_literal: true

class Document < ApplicationRecord
  has_one_attached :archive

  scope :add_on, lambda { |zip_entry|
                   attach(io: zip_entry,
                          filename: zip_entry.name, content_type: 'zip')
                 }
end
