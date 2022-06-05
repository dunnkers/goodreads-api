require "functions_framework"

FunctionsFramework.http("hello") do |request|
  "Hello, world!\n"
end


# require 'json'
# require 'sinatra'
# require 'redis'
# require_relative 'fetch-shelves'

# $redis = Redis.new

# get '/' do
#     content_type :json
#     response['Access-Control-Allow-Origin'] = '*'

#     shelves = $redis.get('shelves') # stored in JSON
#     return shelves ? shelves : JSON.generate(fetchShelves())
# end

# get '/force-update' do
#     content_type :json
#     response['Access-Control-Allow-Origin'] = '*'
#     return JSON.generate(fetchShelves())
# end
