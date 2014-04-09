module Writefully
  class ApplicationController < ActionController::Base

    def authenticate_wf_owner!
      redirect_to signin_path unless wf_owner_signed_in?
    end

    def wf_owner_signed_in?
      current_wf_owner.present?
    end

    private 

    helper_method :current_wf_owner

    def current_wf_owner
      @current_owner ||= Authorship.where(id: session[:owner_id]).first if session[:owner_id]
    end
  end
end
