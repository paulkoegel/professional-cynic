class Galleryship < ActiveRecord::Base
  belongs_to :gallery
  belongs_to :image

  validates :gallery, :presence => true
  validates :image, :presence => true
  validates :image_id, :uniqueness => {:scope => :gallery_id}
end
