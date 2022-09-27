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
    end
  end

  describe '#index' do
    it 'renders the index template' do
      get :index
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
end
