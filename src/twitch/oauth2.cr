module Twitch
  # An enum representing the possible OAuth2 scopes
  # applicable to the API
  @[Flags]
  enum Scope
    None

    # Read whether a user is subscribed to your channel.
    ChannelCheckSubscription

    # Trigger commercials on channel.
    ChannelCommercial

    # Write channel metadata (game, status, etc).
    ChannelEditor

    # Add posts and reactions to a channel feed.
    ChannelFeedEdit

    # View a channel feed.
    ChannelFeedRead

    # Read nonpublic channel information, including email address and stream key.
    ChannelRead

    # Reset a channel’s stream key.
    ChannelStream

    # Read all subscribers to your channel.
    ChannelSubscriptions

    # Log into chat and send messages.
    ChatLogin

    # Manage a user’s collections (of videos).
    CollectionsEdit

    # Manage a user’s communities.
    CommunitiesEdit

    # Manage community moderators.
    CommunitiesModerate

    # Use OpenID Connect authentication.
    OpenID

    # Turn on/off ignoring a user. Ignoring a user means you cannot see him type,
    # receive messages from him, etc.
    UserBlocksEdit

    # Read a user’s list of ignored users.
    UserBlocksRead

    # Manage a user’s followed channels.
    UserFollowsEdit

    # Read nonpublic user information, like email address.
    UserRead

    # Read a user’s subscriptions.
    UserSubscriptions

    # Turn on Viewer Heartbeat Service ability to record user data.
    ViewingActivityRead
  end

  # A Twitch OAuth2 token.
  #
  # ```
  # token = Token.new("abc", scopes: ["channel_read"])
  # token.to_s                # => "OAuth2 abc"
  # token.scope.channel_read? # => true
  # token.scope.chat_login?   # => false
  # ```
  struct Token
    # The raw token string
    getter token : String

    # The type of token
    getter type : String

    # The scopes this token has access to
    getter scope : Scope

    # Initializer for easily constructing a Token from an OAuth2
    # flow response. `scopes` is expected to be an array of scope strings.
    def initialize(@token, scopes = ["none"], @type = "Bearer")
      @scope = scopes.map { |string| Scope.parse(string) }.reduce { |memo, e| memo | e }
    end

    # Returns the token, prefixed with OAuth2
    def to_s
      "OAuth #{token}"
    end
  end
end
