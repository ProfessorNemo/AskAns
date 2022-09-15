# frozen_string_literal: true

class PasswordResetsController < ApplicationController
  # пароль можно сбрасывать, если юзер еще в систему не вошел. Поскольку
  # юзер может войти в свой профиль и там пароль поменять
  before_action :require_no_authentication
  before_action :check_user_params, only: %i[edit update]
  before_action :set_user, only: %i[edit update]

  # отправить инструкции по сбросу пароля
  def create
    # найдем юзера по его емэйлу, взяв его из params[:email]
    # В params[:email] email будет доступен, потому что в форме "new"
    # email отправляется (f.label :email)
    @user = User.find_by email: params[:email]

    return if @user.blank?

    # Сгенерировать спец. токен, с помощью которого можно идентифицировать, что это
    # тот юзер сбрасывает email, который имеет на это право, а не левый. И этот
    # токен мы будем использовать, как одноразовый пароль
    @user.set_password_reset_token

    # Если юзер присутствует:
    # with(user: @user) - юзер будет установлен в @user, а user - это ключ,
    # который используется в params[:user] (см. class PasswordResetMailer)
    # deliver_later - поставит отправку письма в очередь и отправка произойдет
    # в фоновом режиме, в очередь и браузер юзера не зависнет. Если отправка из
    # фоновой задачи - то deliver_now. Из контроллера лучше использовать "deliver_later"
    PasswordResetMailer.with(user: @user).reset_email.deliver_later

    # не хочу для злоумышленников подсказывать, если ли юзер с таким емэйлом на сайте или нет.
    # если есть, то будут получены инструкции
    flash[:success] = t '.success'
    # редирект на страницу входа в систему
    redirect_to new_session_path
  end

  # Найти юзера по токену и emaily
  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t '.success'
      redirect_to new_session_path
    else
      render :edit
    end
  end

  private

  # Если skip_old_password присутствует, то мы не требуем ввода старого пароля (см. User).
  # Старый пароль юзер не помнит, поэтому добавляем аттрибут ".merge(skip_old_password: true)"
  def user_params
    params.require(:user).permit(:password, :password_confirmation).merge(skip_old_password: true)
  end

  def check_user_params
    redirect_to(new_session_path, flash: { warning: t('.fail') }) if params[:user].blank?
  end

  # Найти юзера по токену и емейлу
  def set_user
    @user = User.find_by email: params[:user][:email],
                         password_reset_token: params[:user][:password_reset_token]

    return if @user&.password_reset_period_valid?

    #  Если не получилось найти юзера и срок действия токена истек
    redirect_to(new_session_path, flash: { warning: t('.fail') })
  end
end
