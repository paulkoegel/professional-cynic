class AdminControllers::ImagesController < AdminController

  def index
    @images = Image.all
  end

  def new
  end

  def create
    @image = Image.find_or_initialize_by_hash_checksum params[:image][:hash_checksum]
    @image.attributes = params[:image]
    respond_to do |format|
      format.json do
        if @image.save
          render json: @image
        else
          render json: {msg: 'Publishment could not be created'}, status: 422
        end
      end
    end
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
