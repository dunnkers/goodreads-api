require 'goodreads'
require 'nokogiri'
require 'open-uri'
require 'redis'
require 'json'

GOODREADS_API_KEY = ENV["GOODREADS_API_KEY"]
GOODREADS_USER_ID = ENV["GOODREADS_USER_ID"]

if not GOODREADS_API_KEY
    abort "Error: Environment variable `GOODREADS_API_KEY` not set."
end

if not GOODREADS_USER_ID
    abort "Error: Environment variable `GOODREADS_USER_ID` not set."
end

$redis = Redis.new
$client = Goodreads::Client.new(api_key: GOODREADS_API_KEY)

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
    end

    # grab cover
    coverImage = grabBookCover(book.book.link)
    if coverImage
        imagePath = coverImage["src"]
        book.book.image_url = imagePath
        $redis.set("cover_#{book.id}", imagePath)
        puts "Grabbed: #{imagePath}"
    end

    return book
end

def fetchShelves
    read = $client.shelf(GOODREADS_USER_ID, "read")
    read.books = read.books.map { |book| fixBookCover(book) }
    current = $client.shelf(GOODREADS_USER_ID, "currently-reading")
    current.books = current.books.map { |book| fixBookCover(book) }
    shelves = {
        "read" => read,
        "current" => current
    }

    $redis.set('shelves', JSON.generate(shelves))
    return shelves
end