# frozen_string_literal: true

# Контроллер, управляющий пользователями. Должен уметь:
#
#   1. Показывать страницу пользователя
#   2. Создавать новых пользователей
#   3. Позволять пользователю редактировать свою страницу
#
class UsersController < ApplicationController
  before_action :set_user!, only: %i[show edit]

  # Это действие отзывается, когда пользователь заходит по адресу /users
  def index
    @users = User.sorted
    @users = @users.decorate
  end

  def new; end

  def edit; end

  # Это действие отзывается, когда пользователь заходит по адресу /users/:id,
  # например /users/1.
  def show
    @user = @user.decorate
    # Болванка вопросов для пользователя
    @questions = [
      Question.create(text: 'Как дела?', user_id: '5'),
      Question.create(
        text: 'В чем смысл жизни?', user_id: '6'
      )
    ]

    # Болванка для нового вопроса
    @new_question = Question.new
  end

  private

  def set_user!
    @user = User.find params[:id]
  end

  def user_params
    params.require(:user)
          .permit(:email, :name, :username, :password, :password_confirmation, :old_password)
  end

  def question_params
    params.require(:question).permit(:text)
  end
end
