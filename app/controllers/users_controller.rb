class UsersController < ApplicationController

  before_action :set_user, only: [:show, :edit, :update, :comment, :collect]

  def show
    
  end

  def comment
    @user_replies = @user.replies
  end

  def collect
    @user_collect = @user.favorited_posts
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
