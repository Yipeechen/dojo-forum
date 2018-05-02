class PostsController < ApplicationController
  before_action :authenticate_user!

  before_action :set_post, only: [:show, :edit, :update, :destroy]
  
  def index
    @posts = Post.page(params[:page]).per(10)
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      flash[:notice] = "post was successfully created"
      redirect_to posts_path
    else
      flash.now[:alert] = "post was failed to create"
      render :new
    end
  end

  def show
    
  end

  def edit
    
  end

  def update
    if @post.update(post_params)
      flash[:notice] = "post was successfully updated"
      redirect_to post_path(@post)
    else
      flash.now[:alert] = "post was failed to update"
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path
    flash[:alert] = "post was deleted"
  end

  private

  def post_params
    params.require(:post).permit(:title, :description, :image)
  end

  def set_post
    @post = Post.find(params[:id])
  end
end

