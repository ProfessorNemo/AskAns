# frozen_string_literal: true

RSpec.describe Question, type: :model do
  let(:user) { create(:id) }
  let(:question) { build(:question_id) }

  context 'creating a question' do
    it 'when the user is the author' do
      expect(user.role).to eq('basic')

      expect(question.author == user).to be_truthy

      expect(question).to be_new_record

      expect(question.author).not_to be_new_record
    end

    it 'when a guest asks a question' do
      question = build(:guest)

      expect(question.author).to be_nil

      expect(question).to be_new_record
    end
  end

  specify '#scope' do
    user = create(:another_user)

    question.user = user

    question.save

    hashtag = question.send(:create_hashtags)

    expect(described_class.all_by_hashtags(hashtag).count).to eq(3)

    expect(described_class.answered.count).to eq(0)

    expect(described_class.unanswered.count).to eq(1)

    # 3 hashtags are generated from one question
    expect(hashtag.map(&:text)).to be_all(String)

    expect(hashtag.count).to eq(3)
  end
end
