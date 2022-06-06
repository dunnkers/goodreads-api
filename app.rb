require "functions_framework"

FunctionsFramework.on_startup do
    require_relative "lib/fetch_shelves"
    fetchShelvesOrUseCache()
end

FunctionsFramework.http("get-shelves") do |request|
    if request.options?
        headers = {
            "Access-Control-Allow-Origin"  => "*",
            "Access-Control-Allow-Methods" => "GET",
            "Access-Control-Allow-Headers" => "Content-Type",
            "Access-Control-Max-Age"       => "3600"
        }
        return [204, headers, []]
    else
        headers = {
            "Access-Control-Allow-Origin" => "*"
        }

        bust_str = request.params["bust"] rescue "false"
        bust = bust_str == "true"
        shelves = fetchShelvesOrUseCache(bust: bust)
        [200, headers, shelves]
    end
end

FunctionsFramework.cloud_event "force-get-shelves" do |event|
    require "JSON"
    message_json = Base64.decode64 event.data["message"]["data"]
    message_hash = JSON.parse(message_json)
    bust = message_hash["bust"]
    logger.info "Busting shelves cache, triggered by pub/sub cloud event."
    fetchShelvesOrUseCache(bust: bust)
end
