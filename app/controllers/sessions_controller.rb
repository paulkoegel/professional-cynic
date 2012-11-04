class SessionsController < ApplicationController

  layout 'admin'

  def new
  end

  def create
    if user = login(params[:email], params[:password], params[:remember_me])
      redirect_back_or_to admin_root_url, :notice => 'Welcome!'
    else
      @email = params[:email]
      flash.now[:error] = 'Login failed =('
      render :new
    end
  end

  def destroy
    logout
    redirect_back_or_to root_url
  end

end
