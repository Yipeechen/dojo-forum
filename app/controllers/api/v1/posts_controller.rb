class Api::V1::PostsController < ApiController
  before_action :authenticate_user!, except: [:index]
  before_action :set_post, only: [:show, :update, :destroy]
  before_action :check_draft, only: [:show]
  before_action :check_authority, only: [:show]

  def index
    @posts = Post.where("status = ? AND authority = ?", true, "All")

    if user_signed_in?
      @posts = @posts.check_authority(current_user)
    end
    render json: @posts
  end

  def show
    if current_user != @post.user
      @post.increment!(:viewed_count)
    end
    render json: {
      title: @post.title,
      category_ids: @post.categories,
      description: @post.description,
      image: @post.image,
      user_id: @post.user_id
    }
  end

  def create
    @post = current_user.posts.new(post_params)
    if params[:commit] == 'Save Draft'
      @post.status = false
      if @post.save
        render json: {
          message: "草稿儲存成功",
          result: @post
        }
      else
        render json: {
          errors: @post.errors
        }
      end
    else
      @post.status = true
      if @post.save
        render json: {
          message: "文章發佈成功",
          result: @post
        }
      else
        render json: {
          errors: @post.errors
        }
      end
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.permit(
      :title, 
      :description, 
      :image, 
      :authority,
      :category_ids => [])
  end

  def check_draft
    unless @post.is_published? || @post.user.id == current_user.id
      render json: {
        errors: "文章不公開"
      }
    end
  end

  def check_authority
    if @post.authority == "Myself"
      unless @post.user.id == current_user.id
        render json: {
        errors: "無此權限觀看文章"
      }
      end 
    elsif @post.authority == "Friends"
      unless @post.user.id == current_user.id || @post.user.all_friends.include?(current_user)
        render json: {
        errors: "無此權限觀看文章"
      }
      end 
    end   
  end
end
