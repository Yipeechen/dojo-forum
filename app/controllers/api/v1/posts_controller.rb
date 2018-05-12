class Api::V1::PostsController < ApiController

  def index
    @posts = Post.where("status = ? AND authority = ?", true, "All")

    if user_signed_in?
      @posts = @posts.check_authority(current_user)
    end
    render json: @posts
  end
end
