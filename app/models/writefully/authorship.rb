module Writefully
  class Authorship < ActiveRecord::Base
    belongs_to :user
    has_many :posts
  end
end
