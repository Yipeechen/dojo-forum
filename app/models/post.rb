class Post < ApplicationRecord
  mount_uploader :image, PhotoUploader

  validates_presence_of :title, :description, :categories, :authority
  
  belongs_to :user

  has_many :post_categories, dependent: :destroy
  has_many :categories, through: :post_categories

  has_many :replies, dependent: :destroy

  has_many :favorites, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :user

  def is_favorited?(user)
    self.favorited_users.include?(user)
  end

  def is_published?
    self.status == true
  end

  def self.check_authority(user)
    self.where("authority = ? OR user_id = ?", "All", user.id).or(where('authority = ? AND user_id IN (?)', "Friends", user.all_friends))
  end
    
end
