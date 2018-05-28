require "../spec_helper"

describe Twitch::Paginator do
  data = {
    %({"data": [1, 2], "pagination": {"cursor": "1"}}),
    %({"data": [3, 4], "pagination": {"cursor": "2"}}),
    %({"data": [], "pagination": {}}),
  }

  describe "#next" do
    it "performs paginated actions" do
      paginator = Twitch::Paginator(Int32).new(4) do |next_cursor|
        cursor = next_cursor.try(&.to_i?) || 0
        Twitch::Page(Int32).from_json(data[cursor])
      end

      paginator.next.should eq [1, 2]
      paginator.next.should eq [3, 4]
      paginator.next.should eq nil
      paginator.items.should eq [1, 2, 3, 4]
    end
  end

  describe "#each" do
    it "pulls all pages yielding each object" do
      paginator = Twitch::Paginator(Int32).new(4) do |next_cursor|
        cursor = next_cursor.try(&.to_i?) || 0
        Twitch::Page(Int32).from_json(data[cursor])
      end

      results = [] of Int32
      paginator.each do |item|
        results << item
      end
      results.should eq [1, 2, 3, 4]
    end
  end
end
