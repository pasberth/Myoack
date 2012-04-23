require 'spec_helper'

describe Myoack::ConfigManager do
  let(:cm) { described_class.new(File.dirname(__FILE__) + '/myoack_home_example') }
  subject { cm }
  its(:configs) { should_not be_nil }
  its(:config_types) { should_not be_nil }
  
  describe "#require_config(:twitter)" do
    let(:cfg) { cm << Myoack::TwitterConfig; cm.require_config(:twitter) }
    subject { cfg }
    its(:site) { should == "https://api.twitter.com" }
    its(:consumer_key) { should == "YOUR_CONSUMER_KEY" }
    its(:consumer_secret) { should == "YOUR_CONSUMER_SECRET" }
    its(:access_token) { should == "YOUR_ACCESS_TOKEN" }
    its(:access_token_secret) { should == "YOUR_ACCESS_TOKEN_SECRET" }
  end

  describe "#require_config(:tumblr)" do
    let(:cfg) { cm << Myoack::TumblrConfig; cm.require_config(:tumblr) }
    subject { cfg }
    its(:site) { should == "http://api.tumblr.com/v2" }
    its(:request_token_url) { should == "http://www.tumblr.com/oauth/request_token" }
    its(:authorize_url) { should == "http://www.tumblr.com/oauth/authorize" }
    its(:access_token_url) { should == "http://www.tumblr.com/oauth/access_token" }
    its(:consumer_key) { should == "YOUR_CONSUMER_KEY" }
    its(:consumer_secret) { should == "YOUR_CONSUMER_SECRET" }
    its(:access_token) { should == "YOUR_ACCESS_TOKEN" }
    its(:access_token_secret) { should == "YOUR_ACCESS_TOKEN_SECRET" }
  end

  describe "#require_config(:tumblr)" do
    let(:cfg) { cm << Myoack::GitHubConfig; cm.require_config(:github) }
    subject { cfg }
    its(:site) { should == "https://api.github.com" }
    its(:authorize_url) { should == "https://github.com/login/oauth/authorize" }
    its(:access_token_url) { should == "https://github.com/login/oauth/access_token" }
    its(:client_id) { should == "YOUR_CLIENT_ID" }
    its(:client_secret) { should == "YOUR_CLIENT_SECRET" }
    its(:access_token) { should == "YOUR_ACCESS_TOKEN" }
  end

  describe "#require_config(:somesite_example)" do
    let(:cfg) { cm << Myoack::OAuthConfig; cm.require_config(:somesite_example) }
    subject { cfg }
    its(:site) { should == "https://www.example.com" }
    its(:consumer_key) { should == "SOMESITE_CONSUMER_KEY_EXAMPLE" }
    its(:consumer_secret) { should == "SOMESITE_CONSUMER_KEY_EXAMPLE" }
    its(:access_token) { should == "SOMESITE_ACCESS_TOKEN_EXAMPL" }
    its(:access_token_secret) { should == "SOMESITE_ACCESS_TOKEN_SECRET_EXAMPLE" }
  end
end