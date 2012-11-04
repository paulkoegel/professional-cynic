class Image < ActiveRecord::Base
  attr_accessible :caption, :width, :height, :url, :taken_at, :title, :file_name, :local_path

  has_many :galleryships
  has_many :galleries, :through => :galleryships

  def url
    Rails.env.production? ? self.remote_url : self.local_url
  end
    
  def local_url
    if self.galleries.first.present?
      "http://localhost:4000/#{self.galleries.first.title.downcase}/#{self.file_name}"
    else
      "http://localhost:4000/#{self.file_name}"
    end
  end

  def thumb_url
    self.url.split('/').insert(-2, 'thumbs').join('/')
  end

end
