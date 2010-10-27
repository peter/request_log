require 'rubygems'
require 'mocha'
require 'rack'
require 'rspec'

$:.unshift(File.join(File.dirname(__FILE__), "..", "lib"))
require 'request_log'

RSpec.configure do |config|
  config.mock_with :mocha
end
