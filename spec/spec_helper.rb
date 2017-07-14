RACK_ENV = 'test'.freeze unless defined?(RACK_ENV)
require File.expand_path(File.dirname(__FILE__) + '/../config/boot')

RSpec.configure do |config|
  config.expect_with :rspec
end
