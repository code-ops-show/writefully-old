require_dependency "writefully/application_controller"

module Writefully
  class HooksController < ApplicationController
    respond_to :json
    before_filter :check_signature

    HMAC_DIGEST = OpenSSL::Digest::Digest.new('sha1')

    class InvalidSignature < StandardError; end

    def create
      self.__send__ request.headers["X-Github-Event"].to_sym
    end

    def ping
      head :ok
    end

    def push
      Writefully.add_job :handyman, { task: :synchronize, 
                                      site_slug: body.repository.name } if branch_match?
      head :ok
    end

    def member
      authorship = Authorship.find_by_uid(body.member.id)
      unless authorship
        Authorship.create_from_data(body.member)
      end
      head :ok
    end

  protected

    def branch_match?
      Site.where(slug: body.repository.name).first.branch == body.ref.split('/').last
    end

    def body
      @_body ||= Hashie::Mash.new(JSON.parse(request.body.read))
    end

    def check_signature
      unless signature == request.headers["X-Hub-Signature"]
        raise InvalidSignature, "Invalid signature" 
      end
    end

    def signature
      'sha1=' + OpenSSL::HMAC.hexdigest(HMAC_DIGEST, 
                                        Writefully.options[:hook_secret], 
                                        request.body.read)
    end
  end
end
