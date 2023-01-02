# frozen_string_literal: true

module Exchange
  module Connection
    BASE_URL = 'http://127.0.0.1:3000/'

    # С пом-ю Faraday можно создавать подключения, настраивать
    # Faraday работает с разными адаптерами (default - Net_HTTP)
    def connection(client)
      Faraday.new(options(client)) do |faraday|
        faraday.adapter Faraday.default_adapter
      end
    end

    private

    # набор опций: заголовки, токен для проверки подлинности
    def options(client)
      {
        headers: {
          accept: 'text/html,application/xhtml+xml,application/xml',
          user_agent: 'Mozilla/5.0 (X11; Linux x86_64)',
          host: BASE_URL,
          connection: 'keep-alive',
          'token' => client.token
        },
        # куда шлем запрос
        url: BASE_URL
      }
    end
  end
end
