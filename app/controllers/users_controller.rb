class UsersController < ApplicationController

  before_action :set_user, only: [:show, :edit, :update, :comment, :collect, :draft, :user_owner, :friend]
  before_action :user_owner, only: [:collect, :draft]

  def show
    @user_posts = @user.posts.where('status = ?', true)
  end

  def comment
    @user_replies = @user.replies
  end

  def collect
    @user_collect = @user.favorited_posts
  end

  def draft
    @user_drafts = @user.posts.where('status = ?', false)
  end

  def friend
    @friends = @user.all_friends 
    @pending_friends = @user.pending_friends
    @requested_friends = @user.requested_friends
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

  def user_owner
   unless @user.id == current_user.id
    flash[:alert] = '非使用者不允許'
    redirect_to user_path(@user)
   end
  end
end
