class Post < Writefully::Post
  wf_taxonomize :playlists, -> { where(type: 'Playlist') }, through: :taggings, source: :tag 
end