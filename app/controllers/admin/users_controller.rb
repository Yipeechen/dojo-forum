class Admin::UsersController < ApplicationController
  before_action :authenticate_admin

  def index
    @users = User.all.order(created_at: :asc)
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      redirect_to admin_users_path
      flash[:notice] = "Role was successfully updated"
    else
      @users = User.all
      render :index
    end
  end

  private

  def user_params
    params.require(:user).permit(:role)
  end
end
