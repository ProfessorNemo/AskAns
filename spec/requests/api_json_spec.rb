# frozen_string_literal: true

RSpec.describe Box::ApiJson do
  let(:path) do
    {
      path_users: 'http://127.0.0.1:3000/api/v1/users?',
      path_questions: 'http://127.0.0.1:3000/api/v1/users/Scarlet_Witch/questions?',
      path_hashtags: 'http://127.0.0.1:3000/api/v1/hashtags?'
    }
  end

  let(:users) do
    VCR.use_cassette('data/users') { described_class.call(path[:path_users]) }
  end
  let(:questions) do
    VCR.use_cassette('data/questions') { described_class.call(path[:path_questions]) }
  end
  let(:hashtags) do
    VCR.use_cassette('data/hashtags') { described_class.call(path[:path_hashtags]) }
  end

  let(:ind) { [] }

  it 'can fetch & parse user data' do
    users.each_with_index do |hash, index|
      ind.push(index) if hash[:username].include?('Scarlet_Witch')
    end

    user = users[ind.first]

    expect(users).to be_a(Array)

    expect(user).to be_a(Hash)

    expect(user).to respond_to(:keys)

    expect(user).to have_key(:id)

    expect(user.any?(String)).not_to be_a(String)

    expect(user[:name]).to eq('Elizabeth')

    expect(user[:email]).to eq('elizabeth-olsen@gmail.com')

    expect(user[:username]).to eq('Scarlet_Witch')

    puts users.inspect
  end

  it 'can fetch & parse question data' do
    question = questions[0]

    expect(questions).to be_a(Array)

    expect(question).to be_a(Hash)

    expect(question).to respond_to(:keys)

    expect(question.keys).to contain_exactly(:id, :answer, :author, :text, :user)

    puts questions.inspect
  end

  it 'can fetch & parse hashtag data' do
    expect(hashtags).to be_a(Array)

    expect(hashtags[0]).to respond_to(:keys)

    expect(hashtags.count).not_to be_nil

    puts hashtags.inspect
  end
end
