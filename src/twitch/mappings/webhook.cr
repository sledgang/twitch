require "onyx-eda/event"

struct Twitch::WebhookEvent(T)
  include Onyx::EDA::Event

  JSON.mapping(
    data: Array(T),
    options: {type: Hash(String, String), default: {} of String => String}
  )

  def initialize(event : WebhookEvent)
    @data = event.data.map(&.as(T))
    @options = event.options
  end

  macro method_missing(call)
    if options.has_key?("{{call}}")
      options["{{call}}"]
    else
      nil
    end
  end
end
