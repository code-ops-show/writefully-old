module Writefully
  class ApplicationController < ActionController::Base

    def authenticate_wf_authorship!
      redirect_to signin_path unless wf_authorship_signed_in?
    end

    def wf_authorship_signed_in?
      current_wf_authorship.present?
    end

    def set_flash(type, object: nil)
      flash[:namespace] = 'writefully'
      flash[:from] = action_name
      flash[:type] = type
      flash[:object_type] = object.class.name
      flash[:object_id]   = object.id
    end

    private 

    helper_method :current_wf_authorship

    def current_wf_authorship
      @current_wf_authorship ||= Authorship.where(id: session[:wf_authorship_id]).first if session[:wf_authorship_id]
    end
  end
end
