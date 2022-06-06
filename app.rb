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


# FunctionsFramework.http("get-shelves") do |request|
#     if request.options?
#         headers = {
#             "Access-Control-Allow-Origin"  => "*",
#             "Access-Control-Allow-Methods" => "GET",
#             "Access-Control-Allow-Headers" => "Content-Type",
#             "Access-Control-Max-Age"       => "3600"
#         }
#         return [204, headers, []]
#     else
#         headers = {
#             "Access-Control-Allow-Origin" => "*",
#             "Content-Type" => "application/json"
#         }

#         bust_str = request.params["bust"] rescue "false"
#         bust = bust_str == "true"
#         shelves = fetchShelvesOrUseCache(bust: bust)
#         puts(shelves)
#         shelves_json = JSON.generate(shelves)

#         return [200, headers, shelves_json]
#     end
# end

FunctionsFramework.cloud_event "force-get-shelves" do |event|
    logger.info "force-get-shelves pub/sub cloud event was triggered."
    message_json = Base64.decode64 event.data["message"]["data"]
    message_hash = JSON.parse(message_json)
    bust = message_hash["bust"]
    logger.info "bust = #{bust}"
    fetchShelvesOrUseCache(bust: bust)
end
