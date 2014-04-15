module Writefully
  class Authorship < ActiveRecord::Base
    belongs_to :user

    has_many :posts
    has_many :owned_sites, class_name: "Writefully::Site", foreign_key: :owner_id

    store_accessor :data, :name, :email, :bio, :uid, :user_name, :auth_token

    def to_s
      data["name"] || data["login"] || data["email"] || data["uid"]
    end

    def self.find_by_uid(uid)
      where("data -> 'uid' = ?", uid.to_s).first
    end

    def self.create_with_omniauth(auth_user)
      create! do |authorship|
        authorship.data = { email: auth_user.email,
                            uid: auth_user.id,
                            bio: auth_user.bio,
                            user_name: auth_user.login,
                            name: auth_user.name }
      end 
    end
  end
end
