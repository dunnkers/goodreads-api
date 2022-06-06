require "functions_framework"

FunctionsFramework.on_startup do
    require_relative "lib/fetch_shelves"
    fetchShelvesOrUseCache()
end

FunctionsFramework.http("get-shelves") do |request|
    puts request.params
    bust = request.params["bust"] rescue false
    return fetchShelvesOrUseCache(bust: bust)
end

FunctionsFramework.cloud_event "force-get-shelves" do |event|
    require "JSON"
    message_json = Base64.decode64 event.data["message"]["data"]
    message_hash = JSON.parse(message_json)
    bust = message_hash["bust"]
    logger.info "Busting shelves cache, triggered by pub/sub cloud event."
    fetchShelvesOrUseCache(bust: bust)
end
