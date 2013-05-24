class AdminControllers::DropboxAccountsController < AdminController

  def new
  end
  
  def show
    @dropbox_account = DropboxAccount.find(params[:id])
  end

  def connect
    dropbox_account = DropboxAccount.first_or_create
    consumer = Dropbox::API::OAuth.consumer(:authorize)
    request_token = consumer.get_request_token
    session[:token] = request_token.token
    session[:token_secret] = request_token.secret
    redirect_to request_token.authorize_url(:oauth_callback => callback_admin_dropbox_account_url(dropbox_account))
  end

  def callback # handle dropbox response (GET)
    dropbox_account = DropboxAccount.find(params[:id])
    consumer = Dropbox::API::OAuth.consumer(:authorize)
    hash = { oauth_token: session[:token], oauth_token_secret: session[:token_secret] }
    request_token = OAuth::RequestToken.from_hash(consumer, hash)
    result = request_token.get_access_token(:oauth_verifier => params[:oauth_token])
    dropbox_account.request_token = result.token
    dropbox_account.request_secret = result.secret

    if dropbox_account.save #&& fetch_dropbox_details
      redirect_to admin_dropbox_account_path(dropbox_account), :notice => 'Successfully integrated Dropbox \o/'
    else
      flash[:error] = 'An error occurred when communicating with Dropbox =( Please try again.'
      redirect_to new_admin_dropbox_account_path
    end
  end

  def disconnect #
    dropbox_account.assign_attributes({:request_token => nil,
                                       :request_secret => nil,
                                       :dropbox_account_name => nil,
                                       :dropbox_account_email => nil,
                                       :dropbox_account_uid => nil}, :without_protection => true)
    if dropbox_account.save
      redirect_to edit_account_path(dropbox_account), :notice => 'Disconnected Dropbox.'
    else
      flash[:error] = 'An error occurred.'
      redirect_to edit_account_path(dropbox_account)
    end
  end

  private

    # def fetch_dropbox_details(dropbox_account)
    #   client = Dropbox::API::Client.new(:token => dropbox_account.request_token, :secret => dropbox_account.request_secret)
    #   if dropbox_account = client.account # fetches account details from the Dropbox API
    #     current_account.dropbox_account_name  = dropbox_account.display_name
    #     current_account.dropbox_account_email = dropbox_account.email
    #     current_account.dropbox_account_uid   = dropbox_account.uid
    #     return current_account.save
    #   else
    #     return false
    #   end
    # end

end
