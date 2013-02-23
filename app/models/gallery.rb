# encoding: UTF-8

class Gallery < ActiveRecord::Base

  attr_accessible :title

  has_many :galleryships
  has_many :images, :through => :galleryships

  before_validation :create_slug

  validates :title, :presence => true
  validates :slug, :presence => true, :uniqueness => true

  def to_param
    self.slug
  end

  private
 
    def create_slug
      self.slug = self.title.underscore.parameterize if self.title
    end

end
