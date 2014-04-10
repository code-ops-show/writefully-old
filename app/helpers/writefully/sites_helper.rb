module Writefully
  module SitesHelper

    STATE_PARTIAL = { 
      true  => 'yes',
      false => 'no'
    }

    def processing_partial site
      'writefully/sites/processing/' + STATE_PARTIAL[site.processing]
    end

    def healthy_partial site
      'writefully/sites/healthy/' + STATE_PARTIAL[site.healthy]
    end
  end
end