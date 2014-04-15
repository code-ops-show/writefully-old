require_dependency "writefully/application_controller"

module Writefully
  class AuthorshipsController < ApplicationController
    before_filter :authenticate_wf_owner!

  end
end
