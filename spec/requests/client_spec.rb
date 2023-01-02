# frozen_string_literal: true

RSpec.describe Exchange::Client do
  describe '#create_question' do
    let(:test_client) { described_class.new([]) }

    it 'creating a question on the user page' do
      body = JSON.dump({ user_id: 7, text: 'What are you doing here?' })

      stub_request(:post, "http://127.0.0.1:3000/users/#{JSON.parse(body)['user_id']}")
        .with(
          body: body,
          headers: {
            'token' => test_client.token
          }
        )
        .to_return(status: 200, body: body, headers: {})
      question = test_client.create_question user_id: 7, text: 'What are you doing here?'

      expect(question['text']).to eq('What are you doing here?')
    end

    it 'raises an error with invalid params' do
      stub_request(:post, 'http://127.0.0.1:3000/users/7')
        .to_raise(StandardError)

      expect { test_client.create_question({}) }.to raise_error(StandardError)
    end
  end

  context 'when the question is updated and the album is created' do
    let(:test_client) { described_class.new(ENV.fetch('TOKEN', 'fake')) }
    let(:user_id) { 7 }

    it 'open question with current id' do
      # JSON.dump - чтобы получить строку на основе хэша
      body = JSON.dump(
        'user_id' => user_id,
        'machine_name' =>	'127.0.0.1',
        'request_method' =>	'GET'
      )

      stub_request(:get, "http://127.0.0.1:3000/users/#{user_id}/edit")
        .with(
          headers: {
            'token' => test_client.token
          }
        )
        .to_return(status: 200, body: body, headers: { content_type: 'application/json' })

      question = test_client.question user_id
      expect(question['user_id']).to eq(user_id)
      expect(WebMock).to have_requested(
        :get, "http://127.0.0.1:3000/users/#{user_id}/edit"
      ).once
    end

    it 'create album with current id' do
      body = JSON.dump(
        'user_id' => user_id,
        'success' => 'true',
        'request_method' =>	'POST',
        'album' => { 'title' => 'Санкт-Петербург',
                     'description' => 'Город теней',
                     'notifications' => '0' }
      )

      stub_request(:post, "http://127.0.0.1:3000/users/#{user_id}/albums")
        .with(
          headers: {
            'token' => test_client.token
          }
        )
        .to_return(status: 302, body: body, headers: { content_type: 'application/json' })

      album = test_client.create_album user_id
      expect(album['album']['description']).to eq('Город теней')
      expect(WebMock).to have_requested(
        :post, "http://127.0.0.1:3000/users/#{user_id}/albums"
      ).once
    end
  end
end
