require "../spec_helper"

def it_parses_scope(string, as scope)
  it "parses #{string} into #{scope}" do
    Twitch::Scope.new(string).should eq scope
  end
end

describe Twitch::Scope do
  it_parses_scope("analytics:read:games", as: Twitch::Scope::AnalyticsReadGames)
  it_parses_scope("bits:read", as: Twitch::Scope::BitsRead)
  it_parses_scope("user:edit", as: Twitch::Scope::UserEdit)
  it_parses_scope("user:read:email", as: Twitch::Scope::UserReadEmail)
end
