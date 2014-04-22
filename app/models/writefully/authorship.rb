module Writefully
  class Authorship < ActiveRecord::Base
    self.table_name = "writefully_authorships"

    belongs_to :user

    has_many :posts
    has_many :owned_sites, class_name: "Writefully::Site", foreign_key: :owner_id

    store_accessor :data, :name, :email, :uid, :user_name, :auth_token

    def to_s
      data["name"] || data["login"] || data["email"] || data["uid"]
    end

    def self.find_by_uid(uid)
      where("data -> 'uid' = ?", uid.to_s).first
    end

    def select_role
      Authorship.count == 0 ? "super_admin" : "collaborator"
    end

    def self.create_from_data(auth_user)
      create! do |authorship|
        authorship.data = { email: auth_user.email,
                            uid: auth_user.id,
                            user_name: auth_user.login,
                            name: auth_user.name,
                            avatar: auth_user.avatar_url }.select { |k,v| v.present? }
                            
        authorship.role = authorship.select_role
      end 
    end
  end
end
