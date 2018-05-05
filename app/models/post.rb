class Post < ApplicationRecord
  mount_uploader :image, PhotoUploader

  validates_presence_of :title, :description, :categories
  
  belongs_to :user
  has_and_belongs_to_many :categories
  has_many :replies, dependent: :destroy

  has_many :favorites, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :user

  def is_favorited?(user)
    self.favorited_users.include?(user)
  end
end
