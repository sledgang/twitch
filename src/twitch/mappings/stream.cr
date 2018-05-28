struct Twitch::Stream
  JSON.mapping(
    id: String,
    user_id: String,
    game_id: String,
    community_ids: Array(String),
    type: String,
    viewer_count: Int32,
    started_at: String, # TODO: Time
    language: String,
    thumbnail_url: String
  )
end
