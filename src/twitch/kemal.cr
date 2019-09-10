require "kemal"
require "openssl/hmac"
require "logger"
require "json"
require "./mappings/*"

class Twitch::Kemal
  CALLBACKS = {
    "users/follows"                => Follow,
    "streams"                      => Stream,
    "users"                        => User,
    "extensions/transactions"      => Transaction,
    "moderation/moderators/events" => Event(ModeratorEvent),
    "moderation/banned/events"     => Event(BanEvent),
    "subscriptions/events"         => Event(SubscriptionEvent),
  }

  macro call_event(path, payload)
    event = WebhookEvent({{CALLBACKS[path]}}).from_json({{payload}})
    @on_{{path.id.gsub(/\//, "_")}}_handlers.try &.each do |handler|
      begin
        handler.call(event)
      rescue ex
        @logger.error <<-LOG
          An exception occurred in a user-defined event handler!
          #{ex.inspect_with_backtrace}
          LOG
      end
    end
  end

  macro event(name, payload)
    @on_{{name.id}}_handlers = [] of WebhookEvent({{payload}}) ->

    def on_{{name.id}}(&handler : WebhookEvent({{payload}}) ->)
      @on_{{name.id}}_handlers << handler
      handler
    end
  end

  {% for path, klass in CALLBACKS %}
    event({{path.gsub(/\//, "_")}}, {{klass}})
  {% end %}

  def initialize(@secret : String = "", @logger = Logger.new(STDOUT))
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
    {% begin %}
      case uri.path
        {% for path in CALLBACKS %}
          when {{path}}
            call_event({{path}}, payload)
        {% end %}
      end
    {% end %}
  end

  def delete_handler(handler : WebhookEvent ->, type : String)
    {% begin %}
      case type
        {% for path in CALLBACKS %}
          when {{path.gsub(/\//, "_")}}
            @on_{{path.id.gsub(/\//, "_")}}_handlers.delete(handler)
        {% end %}
	    else
    		@logger.warn("#{type} is not a valid handler type.")
      end
    {% end %}
  end

  def run
    ::Kemal.run do
      yield
    end
  end

  def run
    run { }
  end
end
