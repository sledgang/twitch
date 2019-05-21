require "./spec_helper"

describe "PING" do
  it "responds with PONG" do
    response = String.build do |io|
      connection = Twitch::IRC::Connection.new(io)
      client = Twitch::IRC::Client.new(connection, "foo", "bar")
      client.dispatch FastIRC::Message.new("PING", nil)
    end
    response.should eq FastIRC::Message.new("PONG", ["tmi.twitch.tv"]).to_s
  end
end
