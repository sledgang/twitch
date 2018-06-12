require "rate_limiter"

class RateLimiter(T)
  class Bucket(K)
    def initialize(@limit : UInt32, @time_span : Time::Span,
                   @delay : Time::Span = 0.seconds)
      @bucket = {} of K => Deque(Time)
    end

    def rate_limited?(key : K, rate_limit_time = Time.now)
      queue = @bucket[key]?

      unless queue
        @bucket[key] = Deque(Time).new(1, rate_limit_time)
        return false
      end

      first_time = queue[0]
      last_time = queue[-1]

      if @limit && (queue.size + 1) > @limit
        return (first_time + @time_span) - rate_limit_time if (first_time + @time_span) > rate_limit_time

        clean_queue(queue, rate_limit_time - @time_span)
      end

      return (last_time + @delay) - rate_limit_time if @delay && (last_time + @delay) > rate_limit_time

      queue.push(rate_limit_time)
      false
    end

    def clean_queue(queue, rate_limit_time = Time.now)
      while queue[0] < rate_limit_time
        queue.shift
      end
    end
  end
end
