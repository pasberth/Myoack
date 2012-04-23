require 'yaml'
require 'myoack/config_manager'

module Myoack

class KeyConfig
  attr_accessor :id
  attr_accessor :type

  def self.id *a
    if a.empty?
      @id
    else
      @id = a[0]
    end
  end
  
  def self.type *a
    if a.empty?
      @type
    else
      @type = a[0]
    end
  end

  def self.config_defaults
    @config_defaults ||= {}
  end

  def self.default key, value
    config_defaults[key.to_s] = value
  end
  
  class << self
    alias auto_config id
    alias config_type type
  end
  
  def initialize config=Config
    @config = config
    self.class.config_defaults.each { |k, v| send(:"#{k}=", v) }
  end
  
  attr_accessor :config
end

class OAuthConfig < KeyConfig
  
  config_type :OAuth

  # *Required*
  # *Example*: "https://api.twitter.com"
  attr_accessor :site

  # *Optional*
  # *Example*: "http://api.twitter.com/oauth/request_token"
  # *Default*: "#@site/oauth/request_token"
  attr_accessor :request_token_url

  # *Optional*
  # *Example*: "http://api.twitter.com/oauth/authorize"
  # *Default*: "#@site/oauth/authorize"
  attr_accessor :authorize_url

  # *Optional*
  # *Example*: "http://api.twitter.com/oauth/access_token"
  # *Default*: "#@site/oauth/access_token"
  attr_accessor :access_token_url
  
  attr_accessor :consumer_key
  attr_accessor :consumer_secret
  attr_accessor :access_token
  attr_accessor :access_token_secret
  
  def authorize!
    url = "http://%s:%s/oauth/authorize?id=#{id}" % [LocalAuthorization::HOST, LocalAuthorization::PORT]
    `open "#{url}"`
  end
  
  def save
    cfg = config.load_keys_file
    cfg[id] = {
      'site' => site,
      'request_token_url' => request_token_url,
      'authorize_url' => authorize_url,
      'access_token_url' => access_token_url,
      'consumer_key' => consumer_key,
      'consumer_secret' => consumer_secret,
      'access_token' => access_token,
      'access_token_secret' => access_token_secret
    }
    config.dump_config_file cfg
  end
  
  def save!
    save
  end
end

Config << OAuthConfig

class OAuth2Config < KeyConfig
  
  config_type :OAuth2

  # *Required*
  # *Example*: "https://github.com/login"
  attr_accessor :site

  # *Optional*
  # *Example*: "https://github.com/login/oauth/authorize"
  # *Default*: "#@site/oauth/authorize"
  attr_accessor :authorize_url

  # *Optional*
  # *Example*: "https://github.com/login/oauth/access_token"
  # *Default*: "#@site/oauth/access_token"
  attr_accessor :access_token_url

  attr_accessor :client_id
  attr_accessor :client_secret
  attr_accessor :access_token
end

Config << OAuth2Config
end