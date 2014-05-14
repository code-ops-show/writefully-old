module Writefully
  module Tools
    class Eraser  < Stationery

      def use
        trash 
        remove_assets
        destroyed = future.destroy
        terminate if destroyed.value
      end

      def trash
        compute_type.by_site(site_id)
                      .where(slug: content.slug)
                        .first.update_attributes(trashed: true)
      end

      def remove_assets
        Writefully::Storage.directory.files.map do |file| 
          file.key if file.key.match(::Regexp.new(index[:slug])) 
        end.compact.each do |key|
          Celluloid::Actor[:pigeons].future.remove(key)
        end
      end

      def destroy
        compute_type.by_site(site_id).where(slug: content.slug).first.destroy
      end

      def directory_exists?
        File.directory?(File.join(Writefully.options[:content], 
                                  index[:site], index[:resource], index[:slug]))
      end
    end
  end
end