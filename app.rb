require "functions_framework"

FunctionsFramework.on_startup do
    require_relative "lib/fetch_shelves"
    fetchShelvesOrUseCache()
end

FunctionsFramework.http("get-shelves") do |request|
    return fetchShelvesOrUseCache()
end


FunctionsFramework.cloud_event "hello_pubsub" do |event|
  name = Base64.decode64 event.data["message"]["data"] rescue "no data"
  logger.info "Hello, #{name}!"
end
