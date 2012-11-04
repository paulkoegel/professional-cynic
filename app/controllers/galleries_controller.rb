class GalleriesController < ApplicationController

  def show
    @gallery = Gallery.find params[:id]
  end

  def index
    @galleries = Gallery.all
  end

end
