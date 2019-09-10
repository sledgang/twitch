require "spec-kemal"
require "../src/twitch/webhook"

Kemal.config.env = "test"
kemal = Twitch::Webhook.new("string").run

describe "Twitch::Webhook" do
  describe "#initialize" do
    describe "get /callback" do
      it "rejects an empty body" do
        get "/callback"
      end
    end
  end
  describe "#check_sha" do
    it "should validate correctly" do
    end
  end
end
