require "twitch/client"
require "twitch/kemal"

# Topic to register follows from twitch user 1337
topic = "https://api.twitch.tv/helix/users/follows?first=1&from_id=1337"

# Time to subscribe to the topic, 864000 maximum
lease_seconds = 864000

# Callback URL for the webhooks
callback = "https://example.com/callback"

# Client to handle subscribing
client = Twitch::Client.new
client.client_id = "TWITCH_CLIENT_ID"

kemal = Twitch::Kemal.new

# Register a handler for when a user follows a channel
kemal.on_users_follows do |payload, params|
  pp payload
  pp params
end

# We use a Channel and spawn to ensure the server is up before we subscribe to the topic
channel = Channel(Nil).new
spawn do
  kemal.run do
    channel.send(nil)
  end
end
channel.receive

# Subscribe to the follow webhook
client.webhook_subscribe(callback, topic, lease_seconds)

# Block this thread to keep the server running
sleep
