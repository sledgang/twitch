struct Twitch::User
  JSON.mapping(
    broadcaster_type: String,
    description: String,
    display_name: String,
    email: String?,
    id: String, # TODO: Int32 converter
    login: String,
    offline_image_url: String,
    profile_image_url: String,
    type: String,
    view_count: Int32
  )
end
