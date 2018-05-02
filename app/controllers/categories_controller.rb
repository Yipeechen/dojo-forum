class CategoriesController < ApplicationController
  def show
    @categories = Category.all
    @category = Category.find(params[:id])
    @posts = @category.posts.page(params[:page]).per(10)
  end
end
