class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :replies, dependent: :restrict_with_error
  has_many :posts

  has_many :favorites, dependent: :destroy
  has_many :favorited_posts, through: :favorites, source: :post

  # 使用者擁有很多朋友：自己加對方
  has_many :friendships, -> {where status: 'accepted'}, dependent: :destroy
  has_many :friends, through: :friendships

  # 使用者擁有很多朋友：對方加自己
  has_many :inverse_friendships, -> {where status: 'accepted'}, class_name: "Friendship", foreign_key:"friend_id"
  has_many :inverse_friends, through: :inverse_friendships, source: :user

  # 使用者擁有很多好友邀請：自己寄給對方
  has_many :pending_friendships, -> {where status: 'pending'}, class_name: "Friendship", dependent: :destroy
  has_many :pending_friends, through: :pending_friendships, source: :friend

  # 使用者擁有很多好友邀請：對方寄給自己
  has_many :requested_friendships, -> {where status: 'pending'}, class_name: "Friendship", foreign_key: "friend_id", dependent: :destroy
  has_many :requested_friends, through: :requested_friendships, source: :user

  mount_uploader :avatar, AvatarUploader

  def admin?
    self.role == "admin"
  end

  def friend?(user)
    self.friends.include?(user) || self.inverse_friends.include?(user)
  end

  def requested_friend?(user)
    self.requested_friends.include?(user)
  end

  def pending_friend?(user)
    self.pending_friends.include?(user)
  end

  def all_friends
    friends = self.friends + self.inverse_friends
    return friends.uniq
  end
end
