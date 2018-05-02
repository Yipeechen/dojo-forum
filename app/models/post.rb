class Post < ApplicationRecord
  mount_uploader :image, PhotoUploader

  has_and_belongs_to_many :categories
end
