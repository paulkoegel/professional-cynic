class GalleriesController < ApplicationController

  def show
    @gallery = Gallery.find_by_slug params[:id]
  end

  def index
    @galleries = Gallery.all
  end

end
