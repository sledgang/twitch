struct Twitch::Follow
  JSON.mapping(
    from_id: String,
    to_id: String,
    followed_at: String # TODO: Time
  )
end
