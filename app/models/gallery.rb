# encoding: UTF-8

class Gallery < ActiveRecord::Base

  attr_accessible :title

  has_many :galleryships
  has_many :images, :through => :galleryships

  before_validation :create_slug

  validates :title, :presence => true
  validates :slug, :presence => true

  private
 
    def create_slug
      self.slug = self.title.underscore.parameterize(sep = '-') if self.title
    end

end
