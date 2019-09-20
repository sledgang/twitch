module Twitch::IDConverter
  def self.from_json(parser : JSON::PullParser)
    parser.read_string.to_i32
  end

  def self.to_json(value : Int32, builder : JSON::Builder)
    builder.scalar(value.to_s)
  end
end

module Twitch::ID64Converter
  def self.from_json(parser : JSON::PullParser)
    parser.read_string.to_i64
  end

  def self.to_json(value : Int64, builder : JSON::Builder)
    builder.scalar(value.to_s)
  end
end
