struct Twitch::Game
  JSON.mapping(
    id: String,
    name: String,
    box_art_url: String
  )
end
