class UsersController < ApplicationController

  before_action :set_user, only: [:show, :edit, :update]

  def show

  end

  def edit
    unless current_user == @user
      redirect_to user_path(@user)
    end
  end

  def update
    @user.update(user_params)
    redirect_to user_path(@user)
  end

  private

  def set_user
     @user = User.find(params[:id])
   end

  def user_params
    params.require(:user).permit(:name, :introduction, :avatar)
  end
end
