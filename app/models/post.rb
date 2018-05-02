class Post < ApplicationRecord
  mount_uploader :image, PhotoUploader
end
