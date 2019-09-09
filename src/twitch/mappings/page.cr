module Twitch
  # :nodoc:
  struct Page(T)
    JSON.mapping(
      total: Int32?,
      data: Array(T),
      pagination: Pagination
    )

    delegate cursor, to: pagination
  end

  # :nodoc:
  struct Pagination
    JSON.mapping(cursor: String?)
  end
end
