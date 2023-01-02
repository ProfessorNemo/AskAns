# frozen_string_literal: true

# для отправки запросов

module Exchange
  module Rest
    include Exchange::Request

    # найти вопрос на стороннем сервисе по его идентификатору
    # "question_id". Здесь мы генерируем путь к вопросу и отправляем
    # self, который будет указывать на клиента
    def question(user_id)
      get "users/#{user_id}/edit", self, {}
    end

    # Создать новый вопрос с заданными параметрами
    def create_question(params)
      post "users/#{params[:user_id]}", self, params
    end

    def create_album(user_id)
      post "users/#{user_id}/albums", self, {}
    end
  end
end

# self будет указывать на Client, потому что в Client "include Helpers::Exchange::Rest".
# Берём self, передаём его в get. Затем в get (см. module Request) передаем "client",
# который в себе содержит токен и затем в подключении (см. module Connection) мы этого
# "client" принимаем и вытаскиваем его токен ('X-Api-Token' => client.token), таким образом
# пристыковывая его к заголовкам.
