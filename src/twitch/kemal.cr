require "kemal"
require "openssl/hmac"

class Twitch::Kemal
  def initialize(@secret : String = "")
    get "/callback" do |env|
      halt(env) unless expecting_challenge(env)
      env.response.content_type = "text/plain"
      env.params.query["hub.challenge"]
    end

    post "/callback" do |env|
      if body = env.request.body
        payload = body.gets_to_end

        # Halt unless the signature is valid
        halt(env) unless check_sha(payload, env.request.headers["x-hub-signature"], @secret) unless @secret == ""

        matching = %r(<https://api.twitch.tv/helix/(\S+)\?(\S+)>; rel="self").match(env.request.headers["link"])
        if matching
          handle_callback($1, payload)
        end
      else
        halt(env)
      end
    end
  end

  # TODO?
  def expecting_challenge(env)
    true
  end

  def check_sha(body, signature, secret)
    "sha256=#{OpenSSL::HMAC.hexdigest(:sha256, secret, body)}" == signature
  end

  def handle_callback(link, payload)
    uri = URI.parse(link)

    case uri.path
    # User Follows
    when "/helix/users/follows"
      # Stream Changed
    when "/helix/streams"
      # User Changed
    when "/helix/users"
      # Extension Transaction Created
    when "/helix/extensions/transactions"
      # Moderator Change Events
    when "/helix/moderation/moderators/events"
      # Channel Ban Change Events
    when "/helix/moderation/banned/events"
      # Subscription Events
    when "/helix/subscriptions/events"
    end
  end

  def run
    ::Kemal.run do
      yield
    end
  end

  def run
    ::Kemal.run
  end
end
