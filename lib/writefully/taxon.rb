module Writefully
  Taxon = Struct.new(:incoming, :existing, :type) do 
    def non_existing
      get_difference.map { |token| Tag.new(build_attributes(token)) }
    end

    def selector
      @selector ||= type.underscore.to_sym
    end

    def get_difference
      (parameterized(incoming) - parameterized(existing)).map { |t| t.titleize }
    end

    def type_attribute 
      selector == :'writefully/tag' ? { type: nil } : { type: selector.to_s.classify }
    end

    def build_attributes token
      type_attribute
        .merge({ name: token, slug: token.parameterize })
    end

    def parameterized items
      items.map { |t| t.parameterize }
    end
  end
end