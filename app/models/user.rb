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

  mount_uploader :avatar, AvatarUploader

  def admin?
    self.role == "admin"
  end
end
