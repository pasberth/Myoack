#!/usr/bin/env ruby
$:.unshift File.dirname(__FILE__) + '/../lib'
require 'myoack/as_lib'
Myoack::LocalAuthorization.run!(:host => Myoack::LocalAuthorization::HOST, :port => Myoack::LocalAuthorization::PORT)