class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :replies, dependent: :restrict_with_error
  has_many :posts

  has_many :favorites, dependent: :destroy
  has_many :favorited_posts, through: :favorites, source: :post

  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships

  has_many :inverse_friendships, class_name: "Friendship", foreign_key: "friend_id"
  has_many :friend_requests, through: :inverse_friendships, source: :user

  mount_uploader :avatar, AvatarUploader

  def admin?
    self.role == "admin"
  end

  def friend?(user)
    self.friends.include?(user)
  end
end
