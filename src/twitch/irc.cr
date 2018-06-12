require "socket"
require "fast_irc"
require "./rate_limiter"

class Twitch::IRC
  private getter socket : IO
  private getter limiter : RateLimiter(String)

  def self.new(nick, token)
    new(TCPSocket.new("irc.chat.twitch.tv", 6667), nick, token)
  end

  def initialize(@socket : IO, @nick : String, @token : String)
    @limiter = RateLimiter(String).new
    limiter.bucket(:join, 50_u32, 15.seconds)
  end

  def run(channels)
    authenticate
    spawn join_channels(channels)
    @connected = true
    FastIRC.parse(socket) do |message|
      spawn dispatch(message)
    end
  end

  def on_message(&@on_message : FastIRC::Message ->)
  end

  def join_channel(channel)
    return unless @connected
    wait = limiter.rate_limited?(:join, "")
    sleep(wait) if wait.is_a?(Time::Span)
    raw_write("JOIN", ["##{channel}"])
  end

  def dispatch(message)
    puts message.inspect
    case message.command
    when "PING"
      pong
    when "PRIVMSG"
      @on_message.try &.call(message)
    end
  end

  private def authenticate
    raw_write("PASS", [@token])
    raw_write("NICK", [@nick])
  end

  private def join_channels(channels)
    channels.each do |channel|
      join_channel(channel)
    end
  end

  private def pong
    raw_write("PONG", ["tmi.twitch.tv"])
  end

  private def raw_write(command, params, prefix = nil, tags = nil)
    FastIRC::Message.new(command, params, prefix: prefix, tags: tags).to_s(socket)
  end
end
