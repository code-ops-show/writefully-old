class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include Transponder::Transmission

  def set_flash(type, object: nil)
    flash[:from] = action_name
    flash[:type] = type
    flash[:object_type] = object.class.name
    flash[:object_id]   = object.id
  end
end
