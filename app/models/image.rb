class Image < ActiveRecord::Base
  attr_accessible :caption, :width, :height, :url, :taken_at, :title, :file_name, :local_path

  has_many :galleryships
  has_many :galleries, :through => :galleryships

  SCALE = 1.61803399 # golden ratio
  # D200 dimensions
  # ===============
  # 3872 / 2592 = 1.49382716

  # golden ratio scaled to 980:
  # 980 / 1.61803399 = 606
  # 980 / 606

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

  def scaled_box_width
    if self.horizontal?
      980
    else
      (self.scaled_box_height.to_f * self.width.to_f / self.height.to_f).round
    end
  end

  def scaled_box_height
    606
  end

  def vertical?
    self.height > self.width
  end

  def horizontal?
    !self.vertical?
  end

end
