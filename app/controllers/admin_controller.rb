class AdminController < ApplicationController

  before_filter :require_login
  before_filter :require_admin

  protected

    def not_authenticated
      redirect_to login_path, alert: 'Please log in.'
    end

    def require_admin
      redirect_to galleries_path, alert: "Admin rights required." unless current_user.is_admin?
    end

end
