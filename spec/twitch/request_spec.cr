require "../spec_helper"

describe Twitch::Request do
  it ".get_bits_leaderboard" do
    time = Time.new(2018, 1, 1)
    request = Twitch::Request.get_bits_leaderboard(
      count: 10,
      period: Twitch::Request::Period::Day,
      started_at: time,
      user_id: 123)

    time_str = URI.escape(Time::Format::ISO_8601_DATE_TIME.format(time))
    request.method.should eq "GET"
    request.path.should eq "/helix/bits/leaderboard"
    request.query.should eq "count=10&period=day&started_at=#{time_str}&user_id=123"
  end

  it ".create_clip" do
    request = Twitch::Request.create_clip(
      broadcaster_id: 123,
      has_delay: true)

    request.method.should eq "POST"
    request.path.should eq "/helix/clips"
    request.query.should eq "broadcaster_id=123&has_delay=true"
  end

  it ".get_clips" do
    request = Twitch::Request.get_clips(
      broadcaster_id: 123,
      game_id: 456,
      id: ["foo", "bar"])

    request.method.should eq "GET"
    request.path.should eq "/helix/clips"
    request.query.should eq "broadcaster_id=123&game_id=456&id=foo&id=bar"
  end

  it ".create_entitlement_url" do
    request = Twitch::Request.create_entitlement_url(
      manifest_id: "foo",
      type: "bar")

    request.method.should eq "POST"
    request.path.should eq "/helix/entitlements/upload"
    request.query.should eq "manifest_id=foo&type=bar"
  end

  it ".get_games" do
    request = Twitch::Request.get_games(
      id: 123,
      name: ["foo", "bar"])

    request.method.should eq "GET"
    request.path.should eq "/helix/games"
    request.query.should eq "id=123&name=foo&name=bar"
  end

  it ".get_game_analytics" do
    request = Twitch::Request.get_game_analytics(game_id: 123)

    request.method.should eq "GET"
    request.path.should eq "/helix/analytics/games"
    request.query.should eq "game_id=123"
  end

  it ".get_top_games" do
    request = Twitch::Request.get_top_games(
      after: "foo",
      before: "bar",
      first: 1)

    request.method.should eq "GET"
    request.path.should eq "/helix/games/top"
    request.query.should eq "after=foo&before=bar&first=1"
  end

  it ".get_streams" do
    request = Twitch::Request.get_streams(
      after: "foo",
      before: "bar",
      community_id: "baz",
      first: 1,
      game_id: [2, 3],
      language: "bar",
      user_id: 123,
      user_login: "baz")

    request.method.should eq "GET"
    request.path.should eq "/helix/streams"
    request.query.should eq "after=foo&before=bar&community_id=baz&first=1&game_id=2&game_id=3&language=bar&user_id=123&user_login=baz"
  end

  it ".get_stream_metadata" do
    request = Twitch::Request.get_stream_metadata(
      after: "foo",
      before: "bar",
      community_id: "baz",
      first: 1,
      game_id: [2, 3],
      language: "bar",
      user_id: 123,
      user_login: "baz")

    request.method.should eq "GET"
    request.path.should eq "/helix/streams/metadata"
    request.query.should eq "after=foo&before=bar&community_id=baz&first=1&game_id=2&game_id=3&language=bar&user_id=123&user_login=baz"
  end

  it ".get_users" do
    request = Twitch::Request.get_users(
      id: 1,
      login: ["foo", "bar"])

    request.method.should eq "GET"
    request.path.should eq "/helix/users"
    request.query.should eq "id=1&login=foo&login=bar"
  end

  it ".get_user_follows" do
    request = Twitch::Request.get_users_follows(
      after: "foo",
      first: 1,
      from_id: 2,
      to_id: 3)

    request.method.should eq "GET"
    request.path.should eq "/helix/users/follows"
    request.query.should eq "after=foo&first=1&from_id=2&to_id=3"
  end

  it ".update_user" do
    request = Twitch::Request.update_user("foo")

    request.method.should eq "PUT"
    request.path.should eq "/helix/users"
    request.query.should eq "description=foo"
  end

  it ".get_videos" do
    request = Twitch::Request.get_videos(
      id: [1, 2],
      user_id: 3,
      game_id: 4,
      after: "after",
      before: "before",
      first: 1,
      language: "language",
      period: Twitch::Request::Period::Day,
      sort: Twitch::Request::Sort::Trending,
      type: Twitch::Request::VideoType::Upload)

    request.method.should eq "GET"
    request.path.should eq "/helix/videos"
    request.query.should eq "id=1&id=2&user_id=3&game_id=4&after=after&before=before&first=1&language=language&period=day&sort=trending&type=upload"
  end
end
