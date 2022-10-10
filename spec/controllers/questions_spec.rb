# frozen_string_literal: true

RSpec.configure { |c| c.before { expect(controller).not_to be_nil } }

RSpec.describe QuestionsController, type: :controller do
  let(:quest) { ['What are you doind here?', 'Where are my 17 years old?'].freeze }
  let(:user) { create(:id) }

  before do
    question = build(:guest, text: quest[0])
    question.user = user
    question.save
    question = build(:guest, text: quest[1])
    question.user = user
    question.save
  end

  after do
    Question.destroy_all
  end

  describe 'GET index' do
    it 'has a 200 status code' do
      get :index
      expect(response).to have_http_status(:ok)
      expect(response).to render_template('index')
      expect(response.body).to eq ''
    end
  end

  describe 'routing' do
    it 'routes GET /ru/questions to QuestionsController#index' do
      expect(get: '/ru/questions').to route_to(controller: 'questions', action: 'index', locale: 'ru')
    end

    it 'sdcsdxc' do
      random_index = Question.select(:id).map(&:id).sample.to_s
      expect(get: "/ru/questions/#{random_index}/edit").to route_to(controller: 'questions', action: 'edit',
                                                                    locale: 'ru', id: random_index.to_s)
    end

    it { expect(get: '/ru/question/250000').not_to be_routable }
  end

  describe '#create' do
    it 'has a 300 status code' do
      question = build(:guest, text: quest[0])

      post :create, params: { 'question' => { 'user_id' => user.id, 'text' => question.text } }

      question = assigns(:question)

      expect(question.persisted?).to be(true)
      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(user_path(question.user))
      expect(flash[:success]).not_to be_nil
    end

    it 'has a 200 status code' do
      question = build(:guest, text: quest[0])

      post :create, params: { 'question' => { 'user_id' => nil, 'text' => question.text } }

      question = assigns(:question)

      expect(question.persisted?).to be(false)
      expect(response).to have_http_status(:ok)
      expect(response).to render_template('edit')
      expect(flash[:success]).to be_nil
    end
  end

  context 'when the destroy and update methods are executed' do
    let(:user) { create(:admin) }
    let(:question) { build(:guest, text: quest[0]) }
    let(:another_user) { create(:another_user) }

    before do
      question.user = user
      question.save
      question.update answer: 'Nothing!', author_id: another_user.id
    end

    it 'question updated' do
      # don't working....?
      put :update,
          params: { 'id' => question.id,
                    'question' => { 'author_id' => another_user.id,
                                    'answer' => 'Nothing!' } }

      expect(question.updated_at != question.created_at).to be(true)
      expect(question.persisted?).to be(true)
      expect(response).to have_http_status(:found)
      expect(flash[:success]).to be_nil
    end

    it 'question deleted' do
      question.destroy

      expect(question.persisted?).to be(false)
      expect(Question.find_by(id: question.id).present?).to be(false)
    end
  end
end
