module Writefully
  module Tools
    class Eraser  < Stationery

      def use
        destroy
      end

      def destroy
        compute_type.by_site(site_id)
                      .where(slug: content.slug)
                        .first.update_attributes(trashed: true)
      end
    end
  end
end