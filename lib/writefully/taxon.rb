module Writefully
  Taxon = Struct.new(:incoming, :existing, :type) do 
    TAG_ATTRIBUTE = 
      { 
        tag:      { type: nil },
        playlist: { type: 'Playlist' }
      }

    def non_existing
      get_difference.map { |token| Tag.new(build_attributes(token)) }
    end

    def selector
      @selector ||= type.underscore.to_sym
    end

    def get_difference
      (parameterized(incoming) - parameterized(existing)).map { |t| t.titleize }
    end

    def build_attributes token
      TAG_ATTRIBUTE[selector]
        .merge({ name: token, slug: token.parameterize })
    end

    def parameterized items
      items.map { |t| t.parameterize }
    end
  end
end