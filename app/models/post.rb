class Post < ApplicationRecord
  mount_uploader :image, PhotoUploader

  validates_presence_of :title, :description, :categories

  has_and_belongs_to_many :categories
end
