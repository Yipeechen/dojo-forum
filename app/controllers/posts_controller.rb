class PostsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  before_action :set_post, only: [:show, :edit, :update, :destroy, :favorite, :unfavorite, :post_owner, :check_draft, :check_authority]
  before_action :post_owner, only: [:edit, :update]
  before_action :check_draft, only: [:show]
  before_action :check_authority, only: [:show]

  layout "site_index", only: [:index, :sort]

  def index
    @posts = Post.where('status = ?', true).page(params[:page]).per(20)
    @categories = Category.all
    if user_signed_in?
      @posts = @posts.check_authority(current_user)
    end
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.new(post_params)
    if params[:commit] == 'Save Draft'
      @post.status = false
      if @post.save
        flash[:notice] = "草稿儲存成功"
        redirect_to post_path(@post)
      else
        flash.now[:alert] = "草稿儲存失敗"
        render :new
      end
    else
      @post.status = true
      if @post.save
        flash[:notice] = "文章發布成功"
        redirect_to post_path(@post)
      else
        flash.now[:alert] = "文章發布失敗"
        render :new
      end
    end
  end

  def show
    @reply = Reply.new
    @replies = @post.replies.page(params[:page]).per(20)
    if current_user != @post.user
      @post.increment!(:viewed_count)
    end
  end

  def edit
    
  end

  def update
    if current_user.admin? || current_user == @post.user
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

  def sort
    @categories = Category.all

    if params[:category_id]
      @category = Category.find(params[:category_id])
      @posts = @category.posts.where('status = ?', true).check_authority(current_user)
    else
      @posts = Post.where('status = ?', true).check_authority(current_user)
    end

    if params[:replies_count]
      @posts = @posts.order(replies_count: :desc).page(params[:page]).per(20)
    elsif params[:last_replied_at]
      @posts = @posts.order(last_reply_created_at: :desc).page(params[:page]).per(20)    
    else
      @posts = @posts.order(viewed_count: :desc).page(params[:page]).per(20)
    end

  end

   def favorite
    @post.favorites.create!(user: current_user)
    redirect_back(fallback_location: root_path)
  end

  def unfavorite
    favorites = Favorite.where(post: @post, user: current_user)
    favorites.destroy_all
    if params[:from_show]
      redirect_back(fallback_location: root_path)  
    end
  end

  private

  def post_params
    params.require(:post).permit(
      :title, 
      :description, 
      :image, 
      :authority,
      :category_ids => [])
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def post_owner
    unless @post.user_id == current_user.id
      flash[:alert] = '非文章擁有者無法編輯'
      redirect_to posts_path
    end
  end

  def check_draft
    unless @post.is_published? || @post.user.id == current_user.id
      flash[:alert] = '文章不公開'
      redirect_to posts_path
    end
  end

  def check_authority
    if @post.authority == "Myself"
      unless @post.user.id == current_user.id
        flash[:alert] = '無此權限觀看文章'
        redirect_to posts_path
      end 
    elsif @post.authority == "Friends"
      unless @post.user.id == current_user.id || @post.user.all_friends.include?(current_user)
        flash[:alert] = '無此權限觀看文章'
        redirect_to posts_path
      end 
    end   
  end
end

