module Twitch
  @[Flags]
  enum Scope
    # View analytics data
    AnalyticsReadGames

    # View bits information
    BitsRead

    # Manage a clip object
    ClipsEdit

    # Manage a user object
    UserEdit

    # Read authorized user's email address
    UserReadEmail

    # Creates a new Scope value from a Twitch OAuth2 scope string
    def self.new(string : String)
      parsed = string.split(':').map(&.capitalize).join
      parse(parsed)
    end
  end

  # Exception to raise when a client has insufficient scopes to access
  # a resource
  class ScopeError < Exception
  end
end
