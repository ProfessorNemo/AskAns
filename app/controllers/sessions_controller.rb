# frozen_string_literal: true

class SessionsController < ApplicationController
  before_action :require_no_authentication, only: %i[new create]
  before_action :require_authentication, only: :destroy

  def new; end

  def create
    # render plain: params.to_yaml and return
    # НЕ "@user", а "user", потому что в представлениях фигурировать не будет
    # authenticate - метод из "has_secure_password" в модели "user". Данный метод принимает строку
    # конвертирует ее в хэш и сверяет с тем хэшем, который есть в БД.
    user = User.find_by email: params[:email]
    if user&.authenticate(params[:password])
      do_sign_in user
    else
      # flash[:warning] = 'Неверный адрес электронной почты и/или пароль!'
      # redirect_to session_path
      # или
      flash.now[:warning] = t '.invalid_creds'
      render :new
    end
  end

  def destroy
    sign_out
    flash[:success] = t '.success'
    redirect_to root_path
  end

  private

  def do_sign_in(user)
    # пускаем юзера в систему
    sign_in user
    # запомнить пользователя, если он того хочет
    remember(user) if params[:remember_me] == '1'
    flash[:success] = t('.success', name: current_user.name_or_email)
    redirect_to root_path
  end
end
