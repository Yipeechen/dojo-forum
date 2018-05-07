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
        flash[:notice] = "文章發布成功"
        redirect_to post_path(@post)
      else
        flash.now[:alert] = "文章發布失敗"
        render :new
      end
    else
      @post.status = false
      if @post.save
        flash[:notice] = "草稿發布成功"
        redirect_to post_path(@post)
      else
        flash.now[:alert] = "草稿發布失敗"
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
    if @post.status == true && params[:commit] == 'Update'
      if @post.update(post_params)
        flash[:notice] = "文章更新成功"
        redirect_to post_path(@post)
      else
        flash.now[:alert] = "文章更新失敗"
        render :edit
      end
    elsif @post.status == false && params[:commit] == 'Submit'
      @post.status = true
      @post.viewed_count = 0

      if @post.update(post_params)
        flash[:notice] = "文章發布成功"
        redirect_to post_path(@post)
      else
        flash.now[:alert] = "文章發布失敗"
        render :edit
      end
    else
      if @post.update(post_params)
        flash[:notice] = "草稿更新成功"
        redirect_to post_path(@post)
      else
        flash.now[:alert] = "草稿更新失敗"
        render :edit
      end
    end 
  end

  def destroy
    @post.destroy

    if @post.status == true
      redirect_to posts_path
      flash[:alert] = "文章內容已刪除"
    else
      redirect_to draft_user_path(@post.user)
      flash[:alert] = "草稿內容已刪除"
    end
    
  end

  def feeds
    @users = User.all
    @posts = Post.where('status = ?', true)
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

