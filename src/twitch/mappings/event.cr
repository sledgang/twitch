module Twitch
  struct Event(T)
    JSON.mapping(
      id: String,
      event_type: String,      # TODO: Enum
      event_timestamp: String, # TODO: Time
      version: String,
      event_data: T
    )
  end

  struct ModeratorEvent
    JSON.mapping(
      broadcaster_id: {type: Int32, converter: IDConverter},
      broadcaster_name: String,
      user_id: {type: Int32, converter: IDConverter},
      user_name: String
    )
  end

  struct BanEvent
    JSON.mapping(
      broadcaster_id: {type: Int32, converter: IDConverter},
      broadcaster_name: String,
      user_id: {type: Int32, converter: IDConverter},
      user_name: String,
      expires_at: String # TODO: Time
    )
  end

  struct SubscriptionEvent
    JSON.mapping(
      broadcaster_id: {type: Int32, converter: IDConverter},
      broadcaster_name: String,
      is_gift: Bool,
      plan_name: String,
      tier: String, # TODO: TierConverter?
      user_id: {type: Int32, converter: IDConverter},
      user_name: String,
      message: String
    )
  end
end
