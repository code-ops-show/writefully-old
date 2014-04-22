module Writefully
  class Tagging < ActiveRecord::Base
    self.table_name = "writefully_taggings"

    belongs_to :tag,  class_name: "Writefully::Tag"
    belongs_to :post, class_name: "Writefully::Post"
  end
end
