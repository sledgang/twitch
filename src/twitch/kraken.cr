require "./oauth2"
require "./kraken/*"

module Twitch
  class Kraken
    include REST

    # Oauth2 token associated with this client
    getter token : Token

    # Client ID
    getter client_id : String

    def initialize(@token : Token, @client_id)
    end
  end
end
