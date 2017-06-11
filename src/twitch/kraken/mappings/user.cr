require "./converters"

module Twitch
  struct User
    JSON.mapping({
      display_name:  String,
      id:            {key: "_id", type: UInt64},
      name:          String,
      bio:           String,
      created_at:    {type: Time, converter: TIME_FORMAT},
      updated_at:    {type: Time, converter: TIME_FORMAT},
      logo:          String?,
      email:         String,
      partnered:     Bool,
      notifications: PushSettings,
    })
  end

  struct PushSettings
    JSON.mapping({
      push:  Bool,
      email: Bool,
    })
  end
end
