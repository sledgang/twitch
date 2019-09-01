require "logger"
require "./rest"

# Client for interacting with the Twitch API
class Twitch::Client
  include REST

  def initialize(@logger = Logger.new(STDOUT))
  end
end
