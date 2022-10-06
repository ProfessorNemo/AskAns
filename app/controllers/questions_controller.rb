# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :set_question!, only: %i[edit update destroy show]

  # Проверяем имеет ли юзер доступ к экшену для всей дествий, кроме задавания
  # вопроса, это действие может вызвать даже неавторизованный пользователь.
  before_action :authorize_user, except: %i[create index]

  # Проверяем, имеет ли пользователь право на выполнение запрошенного действия
  before_action :authorize_question!
  # М-д "verify_authorized" доступен из Pundit и он проверит, что мы в нашем "before_action"
  # проверили права доступа. Если проверены не были, то выскочит ошибка. Проверка во всех
  # действиях контроллера
  after_action :verify_authorized, except: %i[create index]

  around_action :skip_bullet, only: :index, if: -> { defined?(Bullet) }

  def index
    @hashtags = Hashtag.where(id: params[:hashtag_ids]) if params[:hashtag_ids]
    @pagy, @questions = pagy Question.includes(%i[author question_hashtags])
                                     .all_by_hashtags(@hashtags)
    @questions = @questions.decorate
  end

  # GET /questions/1/edit
  def edit; end

  # Действие create будет отзываться при POST-запросе по адресу /questions из
  # формы нового вопроса, которая находится в шаблоне на странице
  # /questions/edit
  def create
    @question = Question.new question_params

    @question.author = (current_user.presence)

    # Проверяем капчу вместе с сохранением вопроса. Если в капче была допущена
    # ошибка, она будет добавлена в ошибки @question.errors.
    if check_captcha(@question) && @question.save
      flash[:success] = t('.success')
      redirect_to user_path(@question.user)
    else
      # потому что "new" - шаблона нет
      render :edit
    end
  end

  # Действие update будет отзываться при PUT-запросе из формы редактирования
  # вопроса, которая находится по адресу /questions/:id, например, /questions/1
  #
  # Перед этим действием сработает before_action :load_questions и в переменной
  # @question у нас будет лежать вопрос с нужным id равным params[:id].
  def update
    if @question.update(question_params)
      flash[:success] = t('.success')
      redirect_to user_path(@question.user)
    else
      render :edit
    end
  end

  # Действие destroy будет отзываться при DELETE-запросе со страницы
  # пользователя, которая находится по адресу /users/:id/show.
  #
  # Перед этим действием сработает before_action :load_questions и в переменной
  # @question у нас будет лежать вопрос с нужным id равным params[:id].
  def destroy
    # Перед тем, как удалять вопрос, сохраним пользователя, чтобы знать, куда
    # редиректить после удаления.
    for_decorate(@question)

    user = @question.user

    # Удаляем вопрос
    @question.destroy

    # Отправляем пользователя на страницу адресата вопроса с сообщением
    flash[:success] = t('.success')
    redirect_to user_path(user)
  end

  def show; end

  private

  # Если загруженный из базы вопрос не пренадлежит и текущему залогиненному
  # пользователю — посылаем его с помощью описанного в контроллере
  # ApplicationController метода reject_user.
  def authorize_user
    reject_user unless @question.user == current_user
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_question!
    @question = Question.find(params[:id])
  end

  # Явно задаем список разрешенных параметров для модели Question. Мы говорим,
  # что у хэша params должен быть ключ :question. Значением этого ключа может
  # быть хэш с ключами: :user_id и :text. Другие ключи будут отброшены.
  def question_params
    # Защита от уязвимости: если текущий пользователь — адресат вопроса,
    # он может менять ответы на вопрос, ему доступно также поле :answer.
    if current_user.present? &&
       params[:question][:user_id].to_i == current_user.id
      params.require(:question).permit(:user_id, :text, :answer, hashtag_ids: [])
    else
      params.require(:question).permit(:user_id, :text)
    end
  end

  def for_decorate(resource)
    return unless resource.decorated?

    resource.object
  end

  def check_captcha(model)
    current_user.present? || verify_recaptcha(model: model)
  end

  def skip_bullet
    previous_value = Bullet.enable?
    Bullet.enable = false
    yield
  ensure
    Bullet.enable = previous_value
  end

  # Нужно авторизовать конкретный вопрос или просто использовать модель. Т.е. если
  # вопрос есть, то мы делаем проверку относительно него. Если вопроса нет, то мы говорим
  # что юзер пытается делать что-то относительно ресурса вопроса.
  # Метод "authorize" доступен из Pundit, потому что в ApplicationController заинклюдили
  # concern "Authorization", а этот concern в свою очередь инклюдит Pundit
  def authorize_question!
    authorize(@question || Question)
  end
end
