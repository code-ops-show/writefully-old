module Writefully
  class ApplicationController < ActionController::Base

    def authenticate_wf_owner!
      redirect_to signin_path unless wf_owner_signed_in?
    end

    def wf_owner_signed_in?
      current_wf_owner.present?
    end

    def set_flash(type, object: nil)
      flash[:namespace] = 'writefully'
      flash[:from] = action_name
      flash[:type] = type
      flash[:object_type] = object.class.name
      flash[:object_id]   = object.id
    end

    private 

    helper_method :current_wf_owner

    def current_wf_owner
      @current_owner ||= Authorship.where(id: session[:wf_authorship_id]).first if session[:wf_authorship_id]
    end
  end
end
