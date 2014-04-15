module Writefully
  module Indices
    def self.build_from(modified)
      modified.map do |file_name|
        index_hash_from(index_name_from(remove_content_path(file_name)))
      end
    end

    def self.remove_content_path(file_name)
      file_name.split('/') - Writefully.options[:content].split('/')
    end

    def self.index_name_from(array)
      [:site, :resource, :slug].zip(array).flatten
    end

    def self.index_hash_from(array)
      Hash[*array]
    end
  end
end