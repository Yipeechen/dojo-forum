class Post < ApplicationRecord
  mount_uploader :image, PhotoUploader

  validates_presence_of :title, :description, :categories
  
  belongs_to :user

  has_many :categories_posts, dependent: :destroy
  has_many :categories, through: :categories_posts

  has_many :replies, dependent: :destroy

  has_many :favorites, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :user

  def is_favorited?(user)
    self.favorited_users.include?(user)
  end

  def is_published?
    self.status == true
  end
end
