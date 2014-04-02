class Tag < ActiveRecord::Base
  include Writefully::Tag

  writefully_tokenize :posts
end
