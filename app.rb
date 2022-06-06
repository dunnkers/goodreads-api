require "functions_framework"
require "sinatra/base"

FunctionsFramework.on_startup do
    require_relative "lib/fetch_shelves"
    require "json"
    fetchShelvesOrUseCache()
end

class App < Sinatra::Base
  get "/" do
    content_type :json
    response['Access-Control-Allow-Origin'] = '*'

    bust_str = params[:bust] rescue "false"
    bust = bust_str == "true"
    shelves = fetchShelvesOrUseCache(bust: bust)

    return JSON.generate(shelves)
  end
end

FunctionsFramework.http "get-shelves" do |request|
  App.call request.env
end

FunctionsFramework.cloud_event "force-get-shelves" do |event|
    logger.info "force-get-shelves pub/sub cloud event was triggered."
    message_json = Base64.decode64 event.data["message"]["data"]
    message_hash = JSON.parse(message_json)
    bust = message_hash["bust"]
    logger.info "bust = #{bust}"
    fetchShelvesOrUseCache(bust: bust)
end
