module Writefully
  module FlashHelper
    def render_flash
      render 'flash' if can_flash?
    end

    def can_flash?
      flash.keys.sort == [:from, :object_id, :object_type, :type] and \
      flash.to_hash.values.compact.count == flash_values_count
    end

    def flash_values_count
      action_name == "create" ? 3 : flash.keys.count
    end

    def flash_object
      flash[:object_type].classify.constantize.where(id: flash[:object_id]).first
    end

    def flash_path
      File.join((flash[:namespace] || nil), controller_name, 'flash', flash[:from].to_s, flash[:type].to_s)
    end

    def flash_color
      { success: 'alert-success',
        error:   'alert-danger',
        notice:  'alert-info',
        warn:    'alert-warning' }[flash[:type]]
    end
  end
end