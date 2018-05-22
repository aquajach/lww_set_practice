require 'rack/handler/puma'
require_relative './app'

Rack::Handler::Puma.run App.new