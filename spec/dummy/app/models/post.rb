class Post < Writefully::Post
  writefully_taxonomize :playlists, -> { where(type: 'Playlist') }, through: :taggings, source: :writefully_tag 
end