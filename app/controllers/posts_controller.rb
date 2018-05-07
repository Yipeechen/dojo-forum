class PostsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  before_action :set_post, only: [:show, :edit, :update, :destroy, :favorite, :unfavorite]
  
  def index
    @posts = Post.where('status = ?', true).page(params[:page]).per(20)
    @categories = Category.all
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.new(post_params)
    if params[:commit] == 'Submit'
      @post.status = true
      if @post.save
        flash[:notice] = "Post was successfully created"
        redirect_to post_path(@post)
      else
        flash.now[:alert] = "Post was failed to create"
        render :new
      end
    else
      @post.status = false
      if @post.save
        flash[:notice] = "Draft was successfully created"
        redirect_to post_path(@post)
      else
        flash.now[:alert] = "Draft was failed to create"
        render :new
      end
    end
  end

  def show
    @reply = Reply.new
    @post.increment!(:viewed_count)
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

