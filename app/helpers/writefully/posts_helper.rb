module Writefully
  module PostsHelper
    def publish_tag post
      partial = post.published_at.present? ? 'published' : 'not_published'
      'writefully/posts/' + partial
    end
  end
end