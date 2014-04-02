module Writefully
  class Tagging < ActiveRecord::Base
    belongs_to :tag,  class_name: "Writefully::Tag"
    belongs_to :post, class_name: "Writefully::Post"
  end
end
