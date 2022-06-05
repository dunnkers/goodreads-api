require "functions_framework"
require "google/cloud/firestore"

firestore = Google::Cloud::Firestore.new

FunctionsFramework.http("hello") do |request|

  doc_ref = firestore.doc "people/alovelace"

    doc_ref.set(
        {
            first: "Ada",
            last:  "Lovelace",
            born:  1815
        }
    )

    puts "Added data to the alovelace document in the users collection."

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
