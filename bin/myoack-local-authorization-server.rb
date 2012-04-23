#!/usr/bin/env ruby
require 'myoack/as_lib'
require 'myoack/local_authorization'
Myoack::LocalAuthorization.run!(:host => Myoack::LocalAuthorization::HOST, :port => Myoack::LocalAuthorization::PORT)