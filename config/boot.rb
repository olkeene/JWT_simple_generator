RACK_ENV = ENV['RACK_ENV'] || 'development' unless defined?(RACK_ENV)

require 'bundler/setup'
Bundler.require(:default, RACK_ENV)
Dotenv.load(".env.#{RACK_ENV}", '.env')

require_relative './../lib/jwt_generator'
