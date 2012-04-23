require 'yaml'
require 'net/http'
require 'net/https'
require 'uri'

module Myoack

MYOACK_HOME = File.join(ENV["HOME"], '.myoack')

class Config

  @@configs = {}
  @@config_types = {}
  @@config_classes = {}

  attr_accessor :id

  def initialize options
    self.class.config_defaults.merge(options).each { |k, v| send(:"#{k}=", v) }
  end
  
  def self.configs
    @@configs
  end
  
  def self.config_types
    @@config_types
  end
  
  def self.config_classes
    @@config_classes
  end
  
  def self.load_config_file
    YAML.load_file MYOACK_HOME + '/keys.yml'
  end
  
  def self.dump_config_file cfg
    open MYOACK_HOME + '/keys.yml', 'w' do |f|
      f.write YAML.dump(cfg)
    end
  end
  
  def self.configure_all
    cfg = Config.load_config_file
    cfg.each do |id, sitecfg|
      configure(id, sitecfg) if Config.config_classes.key? id or cfg["site"] && cfg["type"]
    end
    true
  end
  
  def self.configure id, sitecfg=nil, cfgclass=nil
    return nil unless id
    sitecfg ||= Config.load_config_file[id.to_s] or return nil
    cfgclass ||= Config.config_classes[id.to_s] || Config.config_types[sitecfg["type"]]
    Config.add_config id, cfgclass.new(sitecfg.merge(:id => id))
  end
  
  def self.add_config id, cfg
    Config.configs[id.to_s] = cfg
  end

  def self.auto_config id
    Config.config_classes[id.to_s] = self
  end
  
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
  
  def self.config_type type
    Config.config_types[type.to_s] = self
  end
  
  def self.require_config id
    Config.configs[id.to_s] or (configure id; Config.configs[id.to_s]) or raise "Myoack don't know '#{id}'."
  end
end

class OAuthConfig < Config
  
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
    cfg = Config.load_config_file
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
    Config.dump_config_file cfg
  end
  
  def save!
    save
  end
end

class OAuth2Config < Config
  
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
end