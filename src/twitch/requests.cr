# :nodoc:
module Twitch::Request
  extend self

  enum Period
    Day
    Week
    Month
    Year
    All
  end

  def get_bits_leaderboard(count : Int32?, period : Period?, started_at : Time?,
                           user_id : Int32?)
    params = HTTP::Params.build do |form|
      form.add("count", count.to_s) if count
      form.add("period", period.to_s.downcase) if period
      form.add("started_at", Time::Format::ISO_8601_DATE_TIME.format(started_at)) if started_at
      form.add("user_id", user_id.to_s) if user_id
    end

    HTTP::Request.new("GET", "/helix/bits/leaderboard?#{params}")
  end

  def create_clip(broadcaster_id : Int32, has_delay : Bool? = nil)
    params = HTTP::Params.build do |form|
      form.add("broadcaster_id", broadcaster_id.to_s)
      form.add("has_delay", has_delay.to_s) if !has_delay.nil?
    end

    HTTP::Request.new("POST", "/helix/clips?#{params}")
  end

  def get_clips(broadcaster_id : Int32?, game_id : Int32?, id : String | Array(String)?)
    params = HTTP::Params.build do |form|
      form.add("broadcaster_id", broadcaster_id.to_s) if broadcaster_id
      form.add("game_id", game_id.to_s) if game_id
      if id.is_a?(Array)
        id.each do |value|
          form.add("id", value)
        end
      elsif id.is_a?(String)
        form.add("id", id)
      end
    end

    HTTP::Request.new("GET", "/helix/clips?#{params}")
  end

  def create_entitlement_url(manifest_id : String, type : String)
    params = HTTP::Params.build do |form|
      form.add("manifest_id", manifest_id)
      form.add("type", type)
    end

    HTTP::Request.new("POST", "/helix/entitlements/upload?#{params}")
  end

  def get_games(id : Int32 | Array(Int32)?, name : String | Array(String)?)
    params = HTTP::Params.build do |form|
      if id.is_a?(Array)
        id.each do |value|
          form.add("id", value.to_s)
        end
      elsif id.is_a?(Int32)
        form.add("id", id.to_s)
      end

      if name.is_a?(Array)
        name.each do |value|
          form.add("name", value)
        end
      elsif name.is_a?(String)
        form.add("name", name)
      end
    end

    HTTP::Request.new("GET", "/helix/games?#{params}")
  end

  def get_game_analytics(after : String?, first : Int32? = nil,
                         game_id : Int32? = nil)
    params = HTTP::Params.build do |form|
      form.add("after", after) if after
      form.add("first", first.to_s) if first
      form.add("game_id", game_id.to_s) if game_id
    end

    HTTP::Request.new("GET", "/helix/analytics/games?#{params}")
  end

  def get_top_games(after : String?, before : String?, first : Int32?)
    params = HTTP::Params.build do |form|
      form.add("after", after) if after
      form.add("before", before) if before
      form.add("first", first.to_s) if first
    end

    HTTP::Request.new("GET", "/helix/games/top?#{params}")
  end

  def get_streams(after : String?, before : String?, community_id : String | Array(String)?,
                  first : Int32?, game_id : Int32 | Array(Int32)?, language : String | Array(String)?,
                  user_id : Int32 | Array(Int32)?, user_login : String | Array(String)?)
    params = HTTP::Params.build do |form|
      form.add("after", after) if after
      form.add("before", before) if before

      if community_id.is_a?(Array)
        community_id.each do |id|
          form.add("community_id", id)
        end
      elsif community_id.is_a?(String)
        form.add("community_id", community_id)
      end

      form.add("first", first.to_s) if first

      if game_id.is_a?(Array)
        game_id.each do |id|
          form.add("game_id", id.to_s)
        end
      elsif game_id.is_a?(Int32)
        form.add("game_id", game_id.to_s)
      end

      if language.is_a?(Array)
        language.each do |lang|
          form.add("language", lang)
        end
      elsif language.is_a?(String)
        form.add("language", language)
      end

      if user_id.is_a?(Array)
        user_id.each do |id|
          form.add("user_id", id.to_s)
        end
      elsif user_id.is_a?(Int32)
        form.add("user_id", user_id.to_s)
      end

      if user_login.is_a?(Array)
        user_login.each do |user|
          form.add("user_login", user)
        end
      elsif user_login.is_a?(String)
        form.add("user_login", user_login)
      end
    end

    HTTP::Request.new("GET", "/helix/streams?#{params}")
  end

  def get_stream_metadata(after : String?, before : String?, community_id : String | Array(String)?,
                          first : Int32?, game_id : Int32 | Array(Int32)?, language : String? | Array(String)?,
                          user_id : Int32 | Array(Int32)?, user_login : String | Array(String)?)
    params = HTTP::Params.build do |form|
      form.add("after", after) if after
      form.add("before", before) if before

      if community_id.is_a?(Array)
        community_id.each do |id|
          form.add("community_id", id)
        end
      elsif community_id.is_a?(String)
        form.add("community_id", community_id)
      end

      form.add("first", first.to_s) if first

      if game_id.is_a?(Array)
        game_id.each do |id|
          form.add("game_id", id.to_s)
        end
      elsif game_id.is_a?(Int32)
        form.add("game_id", game_id.to_s)
      end

      if language.is_a?(Array)
        language.each do |lang|
          form.add("language", lang)
        end
      elsif language.is_a?(String)
        form.add("language", language)
      end

      if user_id.is_a?(Array)
        user_id.each do |id|
          form.add("user_id", id.to_s)
        end
      elsif user_id.is_a?(Int32)
        form.add("user_id", user_id.to_s)
      end

      if user_login.is_a?(Array)
        user_login.each do |user|
          form.add("user_login", user)
        end
      elsif user_login.is_a?(String)
        form.add("user_login", user_login)
      end
    end

    HTTP::Request.new("GET", "/helix/streams/metadata?#{params}")
  end

  def get_users(id : Int32 | Array(Int32)?, login : String | Array(String)?)
    params = HTTP::Params.build do |form|
      if id.is_a?(Array)
        id.each do |value|
          form.add("id", value.to_s)
        end
      elsif id.is_a?(Int32)
        form.add("id", id.to_s)
      end

      if login.is_a?(Array)
        login.each do |value|
          form.add("login", value)
        end
      elsif login.is_a?(String)
        form.add("login", login)
      end
    end

    HTTP::Request.new("GET", "/helix/users?#{params}")
  end

  def get_users_follows(after : String?, first : Int32?, from_id : Int32?,
                        to_id : Int32?)
    params = HTTP::Params.build do |form|
      form.add("after", after) if after
      form.add("first", first.to_s) if first
      form.add("from_id", from_id.to_s) if from_id
      form.add("to_id", to_id.to_s) if to_id
    end

    HTTP::Request.new("GET", "/helix/users/follows?#{params}")
  end

  def update_user(description : String)
    HTTP::Request.new("PUT", "/helix/users?description=#{description}")
  end

  enum Sort
    Time
    Trending
    Views
  end

  enum VideoType
    All
    Upload
    Archive
    Highlight
  end

  def get_videos(id : Int32 | Array(Int32)?, user_id : Int32?, game_id : Int32?,
                 after : String?, before : String?, first : Int32?,
                 language : String?, period : Period?, sort : Sort?,
                 type : VideoType?)
    params = HTTP::Params.build do |form|
      if id.is_a?(Array)
        id.each do |value|
          form.add("id", value.to_s)
        end
      elsif id.is_a?(Int32)
        form.add("id", id.to_s)
      end

      form.add("user_id", user_id.to_s) if user_id
      form.add("game_id", game_id.to_s) if game_id
      form.add("after", after) if after
      form.add("before", before) if before
      form.add("first", first.to_s) if first
      form.add("language", language)
      form.add("period", period.to_s.downcase) if period
      form.add("sort", sort.to_s.downcase) if period
      form.add("type", type.to_s.downcase) if type
    end

    HTTP::Request.new("GET", "/helix/videos?#{params}")
  end
end
