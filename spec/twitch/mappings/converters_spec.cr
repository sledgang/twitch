require "../../spec_helper"

describe Twitch::IDConverter do
  it "converts strings IDs to Int32" do
    parser = JSON::PullParser.new %("1")
    Twitch::IDConverter.from_json(parser).should eq 1
  end

  it "serializes Int32 to String" do
    json = JSON.build do |builder|
      Twitch::IDConverter.to_json(1, builder)
    end
    json.should eq %("1")
  end
end
