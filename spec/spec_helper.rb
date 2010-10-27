require 'bundler'
Bundler.require(:development)

$:.unshift(File.join(File.dirname(__FILE__), "..", "lib"))
require 'request_log'

RSpec.configure do |config|
  config.mock_with :mocha
end
