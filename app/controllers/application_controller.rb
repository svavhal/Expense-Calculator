class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_action :authenticate_user!
  before_action :set_user_groups
  protect_from_forgery with: :exception

  def set_user_groups
    @groups = current_user.groups if current_user
  end
end
