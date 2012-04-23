#!/usr/bin/env ruby
$:.unshift File.dirname(__FILE__) + '/../lib'
require 'myoack/as_lib'
require 'myoack/local_authorization'
Myoack::LocalAuthorization.run!(:host => Myoack::LocalAuthorization::HOST, :port => Myoack::LocalAuthorization::PORT)