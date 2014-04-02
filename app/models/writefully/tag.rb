module Writefully
  class Tag < ActiveRecord::Base
    include Writefully::Taxonomy

    writefully_tokenize :posts
  end
end
