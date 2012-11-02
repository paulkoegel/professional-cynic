class Image < ActiveRecord::Base
  attr_accessible :caption, :width, :height, :url, :taken_at, :title, :file_name, :local_path

  has_many :galleryships
  has_many :galleries, :through => :galleryships
end
