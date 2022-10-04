class Post < ApplicationRecord
  validates :title, presence: true

  include ImageUploader::Attachment(:image)
end
