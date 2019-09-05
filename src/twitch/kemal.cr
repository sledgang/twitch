require "kemal"
require "openssl/hmac"
require "logger"

class Twitch::Kemal
  CALLBACKS = ["users/follows", "streams", "users", "extensions/transactions",
               "moderation/moderators/events", "moderation/banned/events", "subscriptions/events"]

  macro call_event(name, payload)
    @on_{{name.id}}_handlers.try &.each do |handler|
      begin
        handler.call({{payload}})
      rescue ex
        @logger.error <<-LOG
          An exception occurred in a user-defined event handler!
          #{ex.inspect_with_backtrace}
          LOG
      end
    end
  end

  macro event(name)
    @on_{{name.id}}_handlers = [] of String ->

    def on_{{name.id}}(&handler : String ->)
      @on_{{name.id}}_handlers << handler
      handler
    end
  end

  {% for path in CALLBACKS %}
    event({{path.gsub(/\//, "_")}})
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
            call_event({{path.gsub(/\//, "_")}}, payload)
        {% end %}
      else
        @logger.info("Path:#{uri.path}, Link:#{link}, Payload:#{payload}")
      end
    {% end %}
  end

  def delete_handler(handler : String ->, type : String)
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
