struct Twitch::Stream
  JSON.mapping(
    id: {type: Int32, converter: IDConverter},
    user_id: {type: Int32, converter: IDConverter},
    game_id: {type: Int32, converter: IDConverter},
    community_ids: Array(String),
    type: String,
    viewer_count: Int32,
    started_at: String, # TODO: Time
    language: String,
    thumbnail_url: String
  )
end
