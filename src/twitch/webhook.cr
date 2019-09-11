require "kemal"
require "openssl/hmac"
require "logger"
require "json"
require "./mappings/*"
require "onyx-eda/channel/memory"

class Twitch::Webhook
  CALLBACKS = {
    "users/follows"                => Follow,
    "streams"                      => Stream,
    "users"                        => User,
    "extensions/transactions"      => Transaction,
    "moderation/moderators/events" => Event(ModeratorEvent),
    "moderation/banned/events"     => Event(BanEvent),
    "subscriptions/events"         => Event(SubscriptionEvent),
  }

  {% begin %}
    alias All_Webhooks = {{CALLBACKS.values.map(&.id).join(" | ").id}}
  {% end %}

  def initialize(@secret : String = "", @logger = Logger.new(STDOUT))
    @channel = Onyx::EDA::Channel::Memory.new

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

        links = parse_link_header(env.request.headers["link"])
        if link = links["self"]
          uri = URI.parse(link)
          params = if query = uri.query
                     HTTP::Params.parse(query).to_h
                   else
                     {} of String => String
                   end
          handle_callback(uri.path.lchop("/helix/"), payload, params)
        else
          halt(env)
        end
      else
        halt(env)
      end
    end
  end

  private def parse_link_header(header)
    header.scan(/<(?<url>\S+)>;\s+rel=\"(?<name>\S+)\"/).each_with_object({} of String => String) do |link, links|
      links[link["name"]] = link["url"]
    end
  end

  # TODO?
  def expecting_challenge(env)
    true
  end

  def check_sha(body, signature, secret)
    "sha256=#{OpenSSL::HMAC.hexdigest(:sha256, secret, body)}" == signature
  end

  def handle_callback(link, payload, params)
    {% begin %}
      case link
        {% for path, klass in CALLBACKS %}
          when {{path}}
            event = WebhookEvent({{klass}}).from_json(payload)
            event.options = params
            @channel.emit(event)
            @channel.emit(WebhookEvent(All_Webhooks).new(event))
        {% end %}
      else
        @logger.warn("Received an unknown callback from #{link}")
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

  macro on_event(event, klass)
    def on_{{event}}(**filter, &block : {{klass}} -> _) : Onyx::EDA::Channel::Memory::Subscription({{klass}})
      @channel.subscribe({{klass}}, **filter, &block)
    end
  end

  {% for path, klass in CALLBACKS %}
    on_event({{path.id.gsub(/\//, "_")}}, WebhookEvent({{klass}}))
  {% end %}

  on_event(all, WebhookEvent(All_Webhooks))

  # TODO: SubscribeEvent
  # TODO: UnsubscribeEvent
end
