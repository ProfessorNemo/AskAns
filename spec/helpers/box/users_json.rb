# frozen_string_literal: true

module Box
  module UsersJson
    class << self
      def users
        data = Faraday.new(options) do |faraday|
          faraday.request :url_encoded
          faraday.request  :json
          faraday.response :logger
          faraday.adapter  Faraday.default_adapter
        end

        query = data.get

        JSON.parse(query.body, symbolize_names: true)
      end

      def options
        {
          headers: {
            accept: 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8',
            user_agent: 'Mozilla/5.0 (X11; Linux x86_64; rv:103.0) Gecko/20100101 Firefox/103.0',
            host: '127.0.0.1:3000',
            connection: 'keep-alive',
            'token' => Dotenv.load('.env')['FAKE_TOKEN']
          },
          # куда шлем запрос
          url: 'http://127.0.0.1:3000/api/users'
        }
      end
    end
  end
end

# module Box
#   module UsersJson
#     def self.users
#       url  = 'http://127.0.0.1:3000/api/users'

#       data = Faraday.get(url).body

#       JSON.parse(data, symbolize_names: true)
#     end
#   end
# end
