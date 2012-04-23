require 'myoack/as_lib'

module Myoack
class GitHubConfig < OAuth2Config

  auto_config :github
  default :site, "https://api.github.com"
  default :authorize_url, "https://github.com/login/oauth/authorize"
  default :access_token_url, "https://github.com/login/oauth/access_token"
end

Config << GitHubConfig
end
