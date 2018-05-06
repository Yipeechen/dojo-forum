class CategoriesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]

  def show
    @categories = Category.all
    @category = Category.find(params[:id])
    @posts = @category.posts.page(params[:page]).per(10)
  end
end
