require "http/client"
require "json"
require "oauth2"
require "./mappings/*"

# Mixin providing REST API functionality
module Twitch::REST
  API_HOST = "api.twitch.tv"

  # TODO: OAuth2 facilities
  OAUTH2_API_HOST = "id.twitch.tv"

  @http_client = HTTP::Client.new(API_HOST, tls: true)

  # Issue a request to the Twitch API
  def request(request : HTTP::Request)
    @logger.info("[HTTP OUT] #{request.method} #{request.resource}")
    @logger.debug("[HTTP BODY] #{request.body}") if @logger.debug? && request.body

    # TODO: Response handling (errors, rate limiting)
    request.headers["Host"] = API_HOST
    response = @http_client.exec(request)

    @logger.info("[HTTP IN] #{response.status_code} #{response.status_message} (#{response.body.try(&.size) || 0} bytes)")
    @logger.debug("[HTTP BODY] #{response.body}") if @logger.debug?

    raise "Request failed!\nRequest: #{request.inspect}\nResponse: #{response.inspect}" unless response.success?
    response
  end

  private def parse_single(type, from body)
    parser = JSON::PullParser.new(body)
    object = nil
    parser.on_key("data") do
      parser.read_array do
        object = type.new(parser)
      end
    end
    # TODO: Custom exception
    object || raise "Requested #{type} not found"
  end

  private def assert_scope(scope)
    # TODO: This won't always be an OAuth2 token.
    @scope.includes?(scope) || raise ScopeError.new("OAuth2 token missing scope: #{scope}")
  end

  # Gets a single game by ID.
  def get_game(id : Int32)
    response = request(Request.get_games(id, nil))
    parse_single(Game, from: response.body)
  end

  # Gets a single game by name.
  def get_game(name : String)
    response = request(Request.get_games(nil, name))
    parse_single(Game, from: response.body)
  end

  # Gets multiple game information by name or ID.
  def get_games(ids : Array(Int32)? = nil, names : Array(String)? = nil)
    raise ArgumentError.new("Must provide one of id or name") unless ids || names
    id_count = ids.try(&.size) || 0
    name_count = names.try(&.size) || 0
    raise ArgumentError.new("Can only request 100 games at a time (ids: #{id_count} / 100, logins: #{name_count} / 100)") if (id_count > 100) || (name_count > 100)

    response = request(Request.get_games(ids, names))
    Array(Game).from_json(response.body)
  end

  # Returns a `Paginator(Game)` that can be used to query top games matching
  # the given arguments.
  def get_top_games(first : Int32? = 20)
    Paginator(Game).new(first) do |next_cursor|
      response = request(Request.get_top_games(next_cursor, nil, first))
      Page(Game).from_json(response.body)
    end
  end

  # Returns a `Paginator(Stream)` that can be used to query streams matching
  # the given arguments.
  def get_streams(user_id : Int32 | Array(Int32)? = nil, user_login : String | Array(String)? = nil,
                  community_id : String | Array(String)? = nil, game_id : Int32 | Array(Int32)? = nil,
                  language : String? = nil, first : Int32? = 20)
    Paginator(Stream).new(first) do |next_cursor|
      prepared_request = Request.get_streams(next_cursor, nil, community_id,
        first, game_id, language, user_id, user_login)
      response = request(prepared_request)
      Page(Stream).from_json(response.body)
    end
  end

  # Returns the current authorized `User`
  def current_user
    response = request(Request.get_users(nil, nil))
    parse_single(User, from: response.body)
  end

  # Returns a single `User` by ID
  def user(id : Int32)
    response = request(Request.get_users(id, nil))
    parse_single(User, from: response.body)
  end

  # Returns a single `User` by login name
  def user(login : String)
    response = request(Request.get_users(nil, login))
    parse_single(User, from: response.body)
  end

  # Returns multiple users in bulk by ID or login name
  def users(ids : Array(Int32)? = nil, logins : Array(String)? = nil)
    raise ArgumentError.new("Must supply one of `ids` or `logins`") unless (ids || logins)
    id_count = ids.try(&.size) || 0
    login_count = logins.try(&.size) || 0
    raise ArgumentError.new("Can only request 100 users at a time (ids: #{id_count} / 100, logins: #{login_count} / 100)") if (id_count > 100) || (login_count > 100)

    response = request(Request.get_users(ids, logins))
    Array(User).from_json(response.body, "data")
  end

  # Returns a `Paginator(Follow)` that can be used to query follower
  # relationship between users.
  def get_users_follows(from_user_id : Int32? = nil, to_user_id : Int32? = nil,
                        first : Int32? = 20)
    raise ArgumentError.new("Must supply one of `from_user_id` or `to_user_id`") unless (from_user_id || to_user_id)
    Paginator(Follow).new(first) do |next_cursor|
      response = request(Request.get_users_follows(next_cursor, first, from_user_id, to_user_id))
      Page(Follow).from_json(response.body)
    end
  end
end
