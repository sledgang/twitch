# :nodoc:
module Twitch::Request
  extend self

  def subscribe_to_event(callback : String, mode : String, topic : String, lease_seconds : Int32?,
                         secret : String?)
    body = JSON.build do |json|
      json.object do
        json.field "hub.callback", callback
        json.field "hub.mode", mode
        json.field "hub.topic", topic
        json.field "hub.lease_seconds", lease_seconds if lease_seconds
        json.field "hub.secret", secret if secret
      end
    end

    headers = HTTP::Headers{"Content-Type" => "application/json"}

    HTTP::Request.new("POST", "/helix/webhooks/hub", headers, body.to_s)
  end
end
