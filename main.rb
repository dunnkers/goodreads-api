require 'Goodreads'

client = Goodreads::Client.new(
    api_key: "GbOjze9tMkWgYYTuKHrDtA",
    api_secret: "VUmugs2TnBzxnZqzURRd9rockt6HE5kyO3DgWnzQ"
    )

user_id = 88771324
shelf_name = "currently-reading"
shelf = client.shelf(user_id, shelf_name)

for book in shelf.books do
    print book.book.title + "\n"
end