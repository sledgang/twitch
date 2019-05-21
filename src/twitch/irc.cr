require "fast_irc"
require "./rate_limiter"
require "./irc/*"

class Twitch::IRC::Client
  private getter connection, limiter, tags, log_mode

  def self.new(nick : String, token : String, websocket = false, ssl = true, log_mode = false)
    connection = Twitch::IRC::Connection.new(websocket, ssl)
    new(connection, nick, token, log_mode: log_mode)
  end

  def initialize(@connection : Twitch::IRC::Connection, @nick : String, @token : String, @log_mode = false)
    @limiter = RateLimiter(String).new
    @tags = [] of String
    limiter.bucket(:join, 50_u32, 15.seconds)
    limiter.bucket(:message, 20_u32, 30.seconds)
  end

  def run(channels : Array(String))
    authenticate
    spawn join_channels(channels)
    @connected = true
    connection.on_message do |message|
      spawn dispatch(message)
    end
    connection.run
  end

  def message(channel : String, message : String)
    return unless @connected
    wait = limiter.rate_limited?(:message, channel)
    sleep(wait) if wait.is_a?(Time::Span)
    raw_write("PRIVMSG", [channel, message])
  end

  def on_message(&@on_message : FastIRC::Message ->)
  end

  def join_channel(channel : String)
    return unless @connected
    wait = limiter.rate_limited?(:join, "")
    sleep(wait) if wait.is_a?(Time::Span)
    raw_write("JOIN", ["##{channel}"])
  end

  def leave_channel(channel : String)
    return unless @connected
    raw_write("PART", ["##{channel}"])
  end

  def tags=(tags : Array(String))
    @tags = tags
  end

  def dispatch(message : FastIRC::Message)
    puts "> " + message.to_s if log_mode
    case message.command
    when "PING"
      pong
    when "PRIVMSG"
      @on_message.try &.call(message)
    end
  end

  private def authenticate
    request_tags
    raw_write("PASS", [@token])
    raw_write("NICK", [@nick])
  end

  private def request_tags
    @tags.each do |tag|
      raw_write("CAP", ["REQ", "twitch.tv/#{tag}"])
    end
  end

  private def join_channels(channels : Array(String))
    channels.each do |channel|
      join_channel(channel)
    end
  end

  private def pong
    raw_write("PONG", ["tmi.twitch.tv"])
  end

  private def raw_write(command, params, prefix = nil, tags = nil)
    message = FastIRC::Message.new(command, params, prefix: prefix, tags: tags)
    puts "< " + message.to_s if log_mode
    connection.send(message)
  end
end
