require 'rubygems'
require 'bundler/setup'
require 'williamhill'
require 'webmock/rspec'
require "nokogiri"

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}
