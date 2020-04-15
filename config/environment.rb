require "bundler/setup"
require "sinatra/activerecord" 
require "tty-prompt"
require 'poke-api-v2'
Bundler.require
require_all 'app/models'

ENV['SINATRA_ENV'] ||= 'development'

ActiveRecord::Base.establish_connection(ENV['SINATRA_ENV'].to_sym)

ActiveRecord::Base.logger = nil
