class RepliesController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @reply = @post.replies.build(reply_params)
    @reply.user = current_user
    @reply.save!
    redirect_to post_path(@post)
  end

  def destroy
    @reply = Reply.find(params[:id])

    if current_user.admin? || current_user == @reply.user
      @reply.destroy
      redirect_to post_path(@reply.post)
    end
  end

  def edit
    @reply = Reply.find(params[:id])
  end

  def update
    @reply = Reply.find(params[:id])
    @reply.update_attributes(reply_params)
  end

  private

  def reply_params
    params.require(:reply).permit(:content)
  end
end
