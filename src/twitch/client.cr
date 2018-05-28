require "logger"
require "./rest"

# Client for interacting with the Twitch API
class Twitch::Client
  include REST

  def initialize(@token : OAuth2::AccessToken, @logger = Logger.new(STDOUT))
    @token.authenticate(@http_client)
  end
end
