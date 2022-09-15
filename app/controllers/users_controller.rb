# frozen_string_literal: true

# Контроллер, управляющий пользователями. Должен уметь:
#
#   1. Показывать страницу пользователя
#   2. Создавать новых пользователей
#   3. Позволять пользователю редактировать свою страницу
#
class UsersController < ApplicationController
  # пользователь в систему не вошел
  before_action :require_no_authentication, only: %i[new create]
  # пользователь в систему уже вошел
  before_action :require_authentication, only: %i[edit update destroy]
  before_action :set_user!, only: %i[show edit update destroy]

  # Проверяем имеет ли юзер доступ к экшену, делаем это для всех действий, кроме
  # :index, :new, :create, :show — к этим действиям есть доступ у всех, даже у
  # тех, у кого вообще нет аккаунта на нашем сайте.
  before_action :authorize_user, except: %i[index new create show]

  # Это действие отзывается, когда пользователь заходит по адресу /users
  def index
    @users = User.sorted

    @users = @users.decorate

    # Найти юзеров, зарегистрированных больше года назад, у которых на
    # странице ни одного вопроса
    # User.where('created_at < ?', 1.year.ago).without_questions

    @hashtags = Hashtag.with_questions
  end

  def new
    @user = User.new
  end

  # Действие create будет отзываться при POST-запросе по адресу /users из формы
  # нового пользователя, которая находится в шаблоне на странице /users/new.
  def create
    @user = User.new user_params

    if @user.save
      # Если удалось сохранить, отправляем пользователя на главную с сообщение, что
      # пользователь создан.
      # признак для юзера, что он в систему вошел
      sign_in @user
      WelcomeMailer.with(user: @user).welcome_email.deliver_later
      flash[:success] = t('.success', name: current_user.name_or_email)
      redirect_to root_path
    else
      # Если не удалось по какой-то причине сохранить пользователя, то рисуем
      # (обратите внимание, это не редирект), страницу new с формой
      # пользователя, который у нас лежит в переменной @user. В этом объекте
      # содержатся ошибки валидации, которые выведет шаблон формы.
      render :new
    end
  end

  def edit; end

  # Действие update будет отзываться при PUT-запросе из формы редактирования
  # пользователя, которая находится по адресу /users/:id, например,
  # /users/1
  #
  # Перед этим действием сработает before_action :load_user и в переменной @user
  # у нас будет лежать пользовать с нужным id равным params[:id].
  def update
    # Аналогично create, мы получаем параметры нового (обновленного)
    # пользователя с помощью метода user_params, и пытаемся обновить @user с
    # этими значениями.
    if @user.update user_params
      flash[:success] = t '.success'
      redirect_to user_path(@user)
    else
      # Если не получилось, как и в create рисуем страницу редактирования
      # пользователя, на которой нам будет доступен объект @user, содержащий
      # информацию об ошибках валидации, которые отобразит форма.
      render :edit
    end
  end

  # Это действие отзывается, когда пользователь заходит по адресу /users/:id,
  # например /users/1
  #
  # Перед этим действием сработает before_action :load_user и в переменной @user
  # у нас будет лежать пользовать с нужным id равным params[:id].
  def show
    @user = @user.decorate

    # Достаем вопросы пользователя с помощью метода questions, который мы
    # объявили в модели User (has_many :questions), у результата возврата этого
    # метода вызываем метод order, который отсортирует вопросы по дате.

    @pagy, @questions = pagy @user.questions.includes(:author).sorted

    # Для формы нового вопроса, которая есть у нас на странице пользователя,
    # создаем болванку вопроса, вызывая метод build у результата вызова метода
    # @user.questions.
    @new_question = @user.questions.build

    # Количество вопросов
    @questions_count = @questions.count
    # Количество вопросов с ответами
    @answers_count = @questions.answered.count
    # Количество вопросов без ответа
    @unanswered_count = @questions.unanswered.count
  end

  def destroy
    sign_out
    if @user.destroy
      flash[:success] = t '.success'
      redirect_to root_path
    else
      render :edit
    end
  end

  private

  def set_user!
    @user = User.find params[:id]
  end

  # Явно задаем список разрешенных параметров для модели User. Мы говорим, что
  # у хэша params должен быть ключ :user. Значением этого ключа может быть хэш с
  # ключами: :email, :password, :password_confirmation, :name, :username и
  # :avatar_url. Другие ключи будут отброшены.
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation,
                                 :name, :username, :old_password, :background_color)
  end

  # Если загруженный из базы юзер и текущий залогиненный не совпадают — посылаем
  # его с помощью описанного в контроллере ApplicationController метода
  # reject_user.
  def authorize_user
    reject_user unless @user == current_user
  end
end
