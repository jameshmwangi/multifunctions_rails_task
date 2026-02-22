class UsersController < ApplicationController
  before_action :correct_user, only: [:show, :edit, :update]
  skip_before_action :login_required, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      UserMailer.with(to: @user.email, name: @user.name).welcome.deliver_later(wait: 1.minutes)
      log_in(@user)
      redirect_to user_path(@user.id), notice: 'Account registered successfully.'
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :profile_image)
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to current_user unless current_user?(@user)
  end
end
