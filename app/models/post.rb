class Post < ApplicationRecord
  mount_uploader :image, PhotoUploader

  validates_presence_of :title, :description, :categories
  
  belongs_to :user
  has_and_belongs_to_many :categories
  has_many :replies, dependent: :destroy
end
