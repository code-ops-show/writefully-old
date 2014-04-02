class Post < ActiveRecord::Base
  include Writefully::Post

  writefully_taxonomize :tags,      -> { where(type: nil) },        through: :taggings
  writefully_taxonomize :playlists, -> { where(type: 'Playlist') }, through: :taggings, source: :tag 
end