class RepliesController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @reply = @post.replies.build(reply_params)
    @reply.user = current_user
    @reply.save!
    redirect_to post_path(@post)
  end

  def destroy
    @post = Post.find(params[:post_id])
    @reply = Reply.find(params[:id])

    if current_user.admin? || current_user == @reply.user
      @reply.destroy
      redirect_to post_path(@post)
    end
  end

  def edit
    @post = Post.find(params[:post_id])
    @reply = Reply.find(params[:id])

    render :json => {:post => @post , :replies => @post.replies}
  end

  def update
    @post = Post.find(params[:post_id])
    @reply = Reply.find(params[:id])
    @reply.update_attributes(reply_params)
    render :json => {:post => @post , :replies => @post.replies}
  end

  private

  def reply_params
    params.require(:reply).permit(:content)
  end
end
