class CategoriesController < ApplicationController
  layout "site_index", only: [:show]

  def show
    @categories = Category.all
    @category = Category.find(params[:id])
    @posts = @category.posts.where('status = ?', true).order(created_at: :asc).page(params[:page]).per(20)
    if user_signed_in?
      @posts = @posts.check_authority(current_user)
    end
  end
end
