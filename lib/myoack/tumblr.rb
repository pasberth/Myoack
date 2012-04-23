require 'myoack/as_lib'

module Myoack
class TumblrConfig < OAuthConfig

  auto_config :tumblr
  default :site, "http://api.tumblr.com/v2"
  default :request_token_url, "http://www.tumblr.com/oauth/request_token"
  default :authorize_url, "http://www.tumblr.com/oauth/authorize"
  default :access_token_url, "http://www.tumblr.com/oauth/access_token"
end

Config << TumblrConfig
end
