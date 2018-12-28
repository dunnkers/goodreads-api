require 'goodreads'
require 'json'
require 'sinatra'
require 'nokogiri'
require 'open-uri'
require 'redis'

# initiate redis store
$redis = Redis.new

# initiate goodreads api client
client = Goodreads::Client.new(
    api_key: "GbOjze9tMkWgYYTuKHrDtA",
    api_secret: "VUmugs2TnBzxnZqzURRd9rockt6HE5kyO3DgWnzQ"
    )

user_id = 88771324

def grabBookCover(bookLink)
    doc = Nokogiri::HTML(open(bookLink))
    coverButton = doc.css('.coverButtonContainer .coverButton.enlargeCover')[0]
    
    if coverButton # has cover
        imageSelector = "##{coverButton["id"]}_cover > img"
        image = doc.css(imageSelector)[0]
        return image;
    end
end

def fixBookCover(book)
    coverImagePath = $redis.get("cover_#{book.id}")

    # previously grabbed this cover
    if coverImagePath
        book.book.image_url = coverImagePath
        puts "From Redis store: #{coverImagePath}"
        return book
    else # grab cover
        coverImage = grabBookCover(book.book.link)
        if coverImage
            imagePath = coverImage["src"]
            book.book.image_url = imagePath
            $redis.set("cover_#{book.id}", imagePath)
            puts "Grabbed: #{imagePath}"
        end

        return book
    end
end

# prefetch data
read = client.shelf(user_id, "read")
read.books = read.books.map { |book| fixBookCover(book) }
current = client.shelf(user_id, "currently-reading")
current.books = current.books.map { |book| fixBookCover(book) }

get '/' do
    content_type :json
    shelves = {
        "read" => read,
        "current" => current
    }
    response['Access-Control-Allow-Origin'] = '*'
    JSON.generate(shelves)
end
