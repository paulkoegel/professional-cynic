class GalleriesController < ApplicationController

  def show
    @gallery = Gallery.find_by_slug(params[:id])
    @images = @gallery.images.order('file_name ASC')
  end

  def index
    @galleries = Gallery.all
  end

end
