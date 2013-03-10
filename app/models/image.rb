class Image < ActiveRecord::Base
  attr_accessible :caption, :width, :height, :url, :taken_at, :title, :file_name, :local_path, :dropbox_url, :hash_checksum

  has_many :galleryships
  has_many :galleries, through: :galleryships

  # before_validation :set_shot_at
  # before_validation :set_slug

  validates :hash_checksum, presence: true, uniqueness: true

  SCALE = 1.61803399 # golden ratio
  # D200 dimensions
  # ===============
  # 3872 / 2592 = 1.49382716

  # golden ratio scaled to 980:
  # 980 / 1.61803399 = 606
  # 980 / 606

  def to_param
    self.name
  end

  def url
    self.dropbox_url
    # Rails.env.production? ? self.remote_url : self.local_url
  end
    
  def local_url
    # images that appear in several galleries should be placed in the misc folder and their gallery associations must be set manually
    "/files/#{self.gallery_name || 'misc'}/#{self.file_name}"
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

  def slug
  end

  def name
    self.file_name.sub(/\.(jpg|jpeg|png|gif)\z/i, '')
  end

  def date
    self.shot_at
  end

  def year
    self.shot_at
  end

  def month
    self.shot_at.month
  end

  def day
    self.shot_at.day
  end

  private

    def set_shot_at
      # Date.parsing the entire file name also works but this feels safer - with the convention of having all file names start with a date like '2012-06-23'
      self.shot_at = Date.parse(self.file_name[0..9])
    end

    def set_slug
      return unless self.date && self.title
      self.slug = "#{self.date}_#{self.title.underscore.parameterize}"
    end

end
