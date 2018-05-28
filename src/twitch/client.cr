require "logger"
require "./rest"

# Client for interacting with the Twitch API
class Twitch::Client
  include REST

  @scope : Scope = Scope::None

  def initialize(@token : OAuth2::AccessToken, @logger = Logger.new(STDOUT))
    @token.authenticate(@http_client)
    @token.scope.try do |token|
      # TODO: Don't rely on '+' probably, regular whitepsace may be expected
      parts = token.split('+')
      parts.each do |part|
        @scope = @scope | Scope.new(part)
      end
    end
  end
end
