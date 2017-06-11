require "http"
require "json"
require "./errors"
require "./mappings/*"

module Twitch
  # Mixin for interacting with Twitch's REST API
  module REST
    SSL_CONTEXT = OpenSSL::SSL::Context::Client.new
    API_BASE    = Twitch::API_URL + "/kraken"

    # Executes an HTTP request against the API_BASE url
    def request(method : String, route : String, version = "5", headers = HTTP::Headers.new, body : String? = nil)
      headers["Authorization"] = @token.to_s
      headers["Client-ID"] = @client_id
      headers["Accept"] = "application/vnd.twitchtv.v#{{version}}+json"

      response = HTTP::Client.exec(
        method,
        API_BASE + route,
        headers,
        tls: SSL_CONTEXT
      )

      response.body
    end

    # Macro for checking whether the token has the required scopes
    # to execute a given request
    macro required_scope(scope)
      raise MissingScopeException.new({{scope}}) unless (@token.scope & {{scope}}) == {{scope}}
    end

    # Get the user associated with the client's token.
    def get_user
      required_scope Scope::UserRead

      response = request(
        "GET",
        "/user"
      )

      User.from_json(response)
    end
  end
end
