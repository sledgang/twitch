require "socket"
require "http/web_socket"
require "openssl"

class Twitch::IRC::Connection
  def self.new(websocket = false, ssl = true)
    socket = if websocket
               HTTP::WebSocket.new("irc-ws.chat.twitch.tv", "", tls: ssl)
             else
               tcp = TCPSocket.new("irc.chat.twitch.tv", ssl ? 6697 : 6667)
               if ssl
                 tcp = OpenSSL::SSL::Socket::Client.new(tcp, OpenSSL::SSL::Context::Client.new)
                 tcp.sync = true
               end
               tcp
             end
    new(socket, websocket, ssl)
  end

  def initialize(@socket : IO | HTTP::WebSocket, websocket = false, ssl = true)
  end

  def send(message)
    socket = @socket
    if socket.is_a?(IO)
      message.to_s(socket)
    else
      socket.send(message.to_s)
    end
  end

  def run
    socket = @socket
    if socket.is_a?(IO)
      FastIRC.parse(socket) do |message|
        @on_message.try &.call(message)
      end
    else
      socket.on_message do |message|
        reader = FastIRC::Reader.new(IO::Memory.new(message))
        while msg = reader.next
          @on_message.try &.call(msg)
        end
      end
      socket.run
    end
  end

  def on_message(&@on_message : FastIRC::Message ->)
  end
end
