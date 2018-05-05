class PostsController < ApplicationController
  

  before_action :set_post, only: [:show, :edit, :update, :destroy, :favorite, :unfavorite]
  
  def index
    @posts = Post.page(params[:page]).per(10)
    @categories = Category.all
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.new(post_params)
    if @post.save
      flash[:notice] = "post was successfully created"
      redirect_to posts_path
    else
      flash.now[:alert] = "post was failed to create"
      render :new
    end
  end

  def show
    @reply = Reply.new
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

  def feeds
    @users = User.all
    @posts = Post.all
    @replies = Reply.all
    @popular_posts = @posts.sort_by { |s| s.replies.count } .reverse.take(10)
    @active_users = @users.sort_by { |s| s.replies.count } .reverse.take(10)
  end

   def favorite
    @post.favorites.create!(user: current_user)
    redirect_back(fallback_location: root_path)
  end

  def unfavorite
    favorites = Favorite.where(post: @post, user: current_user)
    favorites.destroy_all
    redirect_back(fallback_location: root_path)
  end

  private

  def post_params
    params.require(:post).permit(
      :title, 
      :description, 
      :image, 
      :category_ids => [])
  end

  def set_post
    @post = Post.find(params[:id])
  end
end

