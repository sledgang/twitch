struct Twitch::Game
  JSON.mapping(
    id: {type: Int32, converter: IDConverter},
    name: String,
    box_art_url: String
  )
end
