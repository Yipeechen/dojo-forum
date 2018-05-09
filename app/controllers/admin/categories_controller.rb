class Admin::CategoriesController < ApplicationController
  
  before_action :authenticate_admin

  before_action :set_category, only: [:update, :destroy]

  def index
    @categories = Category.all

    if params[:id]
      set_category
    else
      @category = Category.new
    end
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:notice] = "分類創建成功"
      redirect_to admin_categories_path

    else
      @categories = Category.all
      render :index
    end
  end

  def update
    
    if @category.update(category_params)
      redirect_to admin_categories_path
      flash[:notice] = "分類更新成功"
    else
      @categories = Category.all
      render :index
    end
  end

  def destroy
    if @category.destroy
      @category.destroy
      flash[:alert] = "分類刪除成功"
      redirect_to admin_categories_path
    else
      flash[:alert] = "分類刪除失敗"
      redirect_to admin_categories_path
    end
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end

  def set_category
    @category = Category.find(params[:id])
  end
end
