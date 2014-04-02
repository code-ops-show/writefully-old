class Post < Writefully::Post
  writefully_taxonomize :playlists, -> { where(type: 'Playlist') }, through: :taggings, source: :tag 
end