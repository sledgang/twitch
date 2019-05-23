require "./spec_helper"

describe RateLimiter do
  describe "#rate_limited?" do
    it "does the thing" do
      limiter = RateLimiter(String).new
      limiter.bucket(:foo, 5_u32, 1.seconds)
      limiter.rate_limited?(:foo, "z64")
      sleep 0.9
      3.times do
        limiter.rate_limited?(:foo, "z64")
      end
      sleep 0.2
      3.times do
        limiter.rate_limited?(:foo, "z64")
      end
      limiter.rate_limited?(:foo, "z64").should be_truthy
    end
  end
end
