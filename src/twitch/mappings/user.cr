struct Twitch::User
  enum Type
    Normal
    Staff
    Admin
    GlobalMod

    def self.new(parser : JSON::PullParser)
      value = parser.read_string
      if value.empty?
        Type::Normal
      else
        parse(value)
      end
    end
  end

  JSON.mapping(
    broadcaster_type: String,
    description: String,
    display_name: String,
    email: String?,
    id: {type: Int32, converter: IDConverter},
    login: String,
    offline_image_url: String,
    profile_image_url: String,
    type: Type,
    view_count: Int32
  )
end
