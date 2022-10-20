# frozen_string_literal: true

module Box
  module ApiJson
    class << self
      def call(path)
        response ||= Faraday.get(path, options).body

        JSON.parse(response.force_encoding('UTF-8'), symbolize_names: true)
      end

      def options
        {
          api_token: Rails.application.credentials[:api_token]
        }
      end
    end
  end
end
