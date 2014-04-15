module Writefully
  module ApplicationHelper
    def path_active?(path)
      request.path == path ? 'active' : nil
    end

    def link_icon(icon)
      content_tag :span, nil,class: "glyphicon glyphicon-#{icon}" if icon
    end

    def activeable_link_to(type, name, path, options = {})
      render 'activeable_link_to', type: type, name: name, path: path, options: options
    end
  end
end