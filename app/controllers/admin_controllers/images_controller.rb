class AdminControllers::ImagesController < AdminController

  def new
  end

  def create
  end

  def show
  end

  def update
    @image = Image.find params[:id]
    @image.update_attributes params[:image]
    redirect_to :back
  end

  def destroy
  end

end
