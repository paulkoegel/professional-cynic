class GalleriesController < ApplicationController

  before_filter :require_login, :except => [:show]

  def new
    @gallery = Gallery.new
  end

  def create
    @gallery = Gallery.new params[:gallery]
    if @gallery.save
      redirect_to gallery_path(@gallery), :notice => 'Gallery successfully created.'
    else
      flash[:error] = 'Gallery could not be created.'
      render :new
    end
  end

  def show
    @gallery = Gallery.find params[:id]
  end

end
