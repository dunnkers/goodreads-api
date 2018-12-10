require 'goodreads'
require 'json'
require 'sinatra'
require 'nokogiri'
require 'open-uri'

client = Goodreads::Client.new(
    api_key: "GbOjze9tMkWgYYTuKHrDtA",
    api_secret: "VUmugs2TnBzxnZqzURRd9rockt6HE5kyO3DgWnzQ"
    )

user_id = 88771324

def grabBookCover(book)
    doc = Nokogiri::HTML(open(book.book.link))
    coverButton = doc.css('.coverButtonContainer .coverButton.enlargeCover')[0]
    if !coverButton # no cover at all
        return book;
    else
        imageSelector = "#" + coverButton["id"] + "_cover > img"
        image = doc.css(imageSelector)[0]
        if !image # that'd be weird, but checking just to be safe.
            return book
        else
            imagePath = image["src"]
            book.book.image_url = imagePath
            puts "Grabbed " + imagePath
            return book
        end
    end
end

get '/' do
    read = client.shelf(user_id, "read")
    read.books = read.books.map { |book| grabBookCover(book) }
    current = client.shelf(user_id, "currently-reading")
    current.books = current.books.map { |book| grabBookCover(book) }

    content_type :json
    shelves = {
        "read" => read,
        "current" => current
    }
    response['Access-Control-Allow-Origin'] = '*'
    JSON.generate(shelves)
end
