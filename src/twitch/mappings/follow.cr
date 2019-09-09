struct Twitch::Follow
  JSON.mapping(
    from_id: {type: Int32, converter: IDConverter},
    to_id: {type: Int32, converter: IDConverter},
    followed_at: String # TODO: Time
  )
end
