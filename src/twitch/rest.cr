require "http/client"
require "json"
require "./requests"

module Twitch::REST
  property client_id : String?

  API_HOST = "api.twitch.tv"

  @http_client = HTTP::Client.new(API_HOST, tls: true)

  def authed_request(request, *, client_id : String? = nil)
    request.headers["client-id"] = client_id if client_id
    request(request)
  end

  def request(request : HTTP::Request)
    @logger.info("[HTTP OUT] #{request.method} #{request.resource}")
    @logger.debug("[HTTP BODY] #{request.body}") if @logger.debug? && request.body

    request.headers["Host"] = API_HOST
    response = @http_client.exec(request)

    @logger.info("[HTTP IN] #{response.status_code} #{response.status_message} (#{response.body.try(&.size) || 0} bytes)")
    @logger.debug("[HTTP BODY] #{response.body}") if @logger.debug?

    raise "Request failed!\nRequest: #{request.inspect}\nResponse: #{response.inspect}" unless response.success?
    response
  end

  def webhook_subscribe(callback, topic, lease_seconds : Int32? = nil, secret : String? = nil, *, unsubscribe = false)
    response = authed_request(Request.subscribe_to_event(callback, "#{"un" if unsubscribe}subscribe", topic, lease_seconds, secret), client_id: @client_id)
  end
end
