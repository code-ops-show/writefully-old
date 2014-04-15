require_dependency "writefully/application_controller"

module Writefully
  class SessionsController < ApplicationController
    def new
      @github_app = Writefully.github_app
    end

    def create
      @auth = Writefully.github_app.get_token(params[:code])
      @github = Github.new oauth_token: @auth.token
      @github_user = @github.users.get
      @owner  = find_or_create_owner 

      refresh_token
      session[:owner_id] = @owner.id
      redirect_to root_path, notice: 'signed_in'
    end

    def destroy
      session[:owner_id] = nil
      redirect_to root_path, notice: 'signed_out'
    end

    protected

    def refresh_token
      @owner.update_attributes(data: @owner.data.merge({ auth_token: @auth.token }))
    end

    def find_or_create_owner
      find_owner || create_owner
    end

    def find_owner
      Authorship.find_by_uid(@github_user.id)
    end

    def create_owner
      if Authorship.count == 0
        Authorship.create_with_omniauth(@github_user)
      else
        return redirect_to root_path, notice: 'owner_exists'
      end
    end
  end
end
