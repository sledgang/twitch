struct Twitch::WebhookEvent(T)
  JSON.mapping(
    data: Array(T)
  )
end
