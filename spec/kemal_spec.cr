require "spec-kemal"
require "../src/twitch/kemal"

Kemal.config.env = "test"
kemal = Twitch::Kemal.new("string").run

describe "Twitch::Kemal" do
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
