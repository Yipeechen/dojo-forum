class PostsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @posts = Post.all
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
    @post = Post.find(params[:id])
  end

  private

  def post_params
    params.require(:post).permit(:title, :description, :image)
  end
end

