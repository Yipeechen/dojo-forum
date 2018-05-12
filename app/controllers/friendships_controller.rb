class FriendshipsController < ApplicationController
  def create
    @friendship = current_user.friendships.build(friend_id: params[:friend_id])
    @friendship.status = 'pending'

    if @friendship.save
      flash[:notice] = "好友邀請送出成功"
      redirect_back(fallback_location: root_path)
    else
      flash[:alert] = @friendship.errors.full_messages.to_sentence
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    if !current_user.pending_friendships.where(friend_id: params[:id]).empty?
      @friendship = current_user.pending_friendships.find_by(friend_id: params[:id])  #取消好友邀請
      flash[:alert] = "取消好友邀請"
    else
      if !current_user.inverse_friendships.where(user_id: params[:id]).empty?
        @friendship = current_user.inverse_friendships.find_by(user_id: params[:id])  #取消好友：對方加自己成為好友
      else
        @friendship = current_user.friendships.find_by(friend_id: params[:id])   #取消好友：自己加對方成為好友
      end
      flash[:alert] = "好友刪除成功"
    end

    @friendship.destroy
    redirect_back fallback_location: root_path
  end

  def confirm
    @friendship = current_user.requested_friendships.find_by(user_id: params[:friendship_id])
    @friendship.update(status: 'accepted')
    flash[:notice] = "確認好友邀請"

    redirect_back fallback_location: root_path
  end

  def reject
    @friendship = current_user.requested_friendships.find_by(user_id: params[:friendship_id])
    @friendship.destroy
    flash[:alert] = "拒絕好友邀請"

    redirect_back fallback_location: root_path
   end

  
end
