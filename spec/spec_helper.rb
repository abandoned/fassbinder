require 'rubygems'
require 'bundler/setup'
require 'rspec'

require File.expand_path('../../lib/fassbinder', __FILE__)

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }
