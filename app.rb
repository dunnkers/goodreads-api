require 'goodreads'
require 'json'
require 'sinatra'

client = Goodreads::Client.new(
    api_key: "GbOjze9tMkWgYYTuKHrDtA",
    api_secret: "VUmugs2TnBzxnZqzURRd9rockt6HE5kyO3DgWnzQ"
    )

user_id = 88771324
read = client.shelf(user_id, "read")
current = client.shelf(user_id, "currently-reading")
 
get '/' do
    content_type :json
    shelves = {
        "read" => read,
        "current" => current
    }
    JSON.generate(shelves)
end
