# A utility class for iterating over paginated HTTP requests. You can fetch the
# next page with `#next`, or exhaust all pages with `#each`, or other
# `Enumerable` methods.
# TODO: This should be able to be iterated over as many times as the user wants
#   without making more requests
class Twitch::Paginator(T)
  include Enumerable(T)

  # The items that have been collected so far
  getter items : Array(T)

  @next_cursor : String? = nil

  # :nodoc:
  def initialize(initial_capacity : Int32, &@block : String? -> Page(T))
    @items = Array(T).new(initial_capacity)
  end

  # Requests the next page. Each page requested with be cached and accessible
  # as `#items`. Returns `nil` when all pages have been exhausted.
  def next : Array(T)?
    page = @block.call(@next_cursor)
    return if page.data.empty?
    @next_cursor = page.cursor
    page.data.each do |item|
      @items << item
    end
    page.data
  end

  # Requests all pages, yielding each individual item.
  def each
    while next_page = self.next
      next_page.each { |item| yield item }
    end
  end
end
