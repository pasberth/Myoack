require 'myoack/as_lib'

module Myoack
class TwitterConfig < OAuthConfig

  auto_config :twitter
  default :site, "https://api.twitter.com"
end
end