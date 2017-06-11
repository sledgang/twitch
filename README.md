# twitch

A binding to the [Twitch API](https://dev.twitch.tv/docs) implemented in [Crystal](https://crystal-lang.org/).

### WIP - Still under heavy design/development!

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  twitch:
    github: y32/twitch
```

## Usage

There are several main components to the library:

- `Twitch::Kraken` - Client for interacting with Twitch's REST API

```crystal
require "twitch/kraken"

twitch = Twitch::Kraken.new(token: "cfabdegwdoklmawdzdo98xt2fo512y")
```

Refer to the documentation for the kinds of requests you can make with this client.

- `Twitch::IRC` - Client for building IRC applications

```crystal
require "twitch/irc"

bot = Twitch::IRC.new(nick: "nekka", token: "cfabdegwdoklmawdzdo98xt2fo512y")

# Create a handler to process incoming messages
bot.on_message do |message|
  # handle this message
end

# Connect to Twitch
bot.run!
```

## Contributors

- [Daniel-Worrall](https://github.com/Daniel-Worrall) - creator, maintainer, spec-man extraordinaire
- [snapcase](https://github.com/snapcase) - creator, maintainer, IRC expert
- [z64](https://github.com/z64) - creator, maintainer, script kiddie
