module Twitch
  # Exception raised when a Token with insufficient scope is used
  # to execute an HTTP request
  class MissingScopeException < Exception
    @required_scope : Scope

    def initialize(@required_scope)
    end

    def message
      "Token has insufficient OAuth scope to execeute this request. Required scope: #{@required_scope}"
    end
  end
end
