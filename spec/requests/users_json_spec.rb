# frozen_string_literal: true

RSpec.describe Box::UsersJson do
  let(:users) do
    VCR.use_cassette('data/users') { described_class.users }
  end

  let(:user) { users[6] }

  it 'can fetch & parse user data' do
    expect(users).to be_a(Array)

    expect(user).to be_a(Hash)

    expect(user).to respond_to(:keys)

    expect(user).to have_key(:id)

    expect(user.any?(String)).not_to be_a(String)

    expect(user[:name]).to eq('Elizabeth')

    expect(user[:email]).to eq('elizabeth-olsen@gmail.com')

    expect(user[:username]).to eq('Scarlet_Witch')

    puts user.inspect
  end
end
