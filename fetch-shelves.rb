require 'goodreads'
require 'nokogiri'
require 'open-uri'
# require 'redis'
# require 'json'
require "google/cloud/firestore"

GOODREADS_API_KEY = ENV["GOODREADS_API_KEY"]
GOODREADS_USER_ID = ENV["GOODREADS_USER_ID"]

if not GOODREADS_API_KEY
    abort "Error: Environment variable `GOODREADS_API_KEY` not set."
end

if not GOODREADS_USER_ID
    abort "Error: Environment variable `GOODREADS_USER_ID` not set."
end

$firestore = Google::Cloud::Firestore.new(project_id: "dunnkers-bookshelf")
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
    cover_doc = $firestore.doc "covers/#{book.id}"
    cover_snapshot = cover_doc.get

    # previously grabbed this cover
    if cover_snapshot.exists?
        image_url = cover_snapshot.data[:image_url]
        book.book.image_url = image_url
        puts "From Firestore: #{image_url}"
        return book
    end

    # grab cover
    bookCover = grabBookCover(book.book.link)
    if bookCover
        image_url = bookCover["src"]
        book.book.image_url = image_url
        cover_doc.set({ image_url: image_url })
        puts "Grabbed: #{image_url}"
    end

    return book
end

def fetchShelves
    read_options = { # See https://www.goodreads.com/api/index#reviews.list
        sort: 'date_read',
        per_page: 200, # max amount that goodreads lets us fetch.
        # -> if more than 200, will need to resort to: `page` option
    }

    read = $client.shelf(GOODREADS_USER_ID, "read", read_options)
    read.books = read.books.map { |book| fixBookCover(book) }
    current = $client.shelf(GOODREADS_USER_ID, "currently-reading")
    current.books = current.books.map { |book| fixBookCover(book) }
    shelves = {
        "read" => read,
        "current" => current
    }

    return shelves
end


def fetchShelvesOrUseCache(bust: false)
    shelves_doc = $firestore.doc "shelves/goodreads_shelf_cache"
    shelves_snapshot = shelves_doc.get

    # use cache if exists
    if shelves_snapshot.exists? || bust
        puts "Using shelves from cache..."
        starting = Time.now
        shelves = shelves_snapshot.data
        ending = Time.now
        elapsed = ending - starting
        puts "✓ retrieved shelves from Firestore in #{elapsed} seconds"
        return shelves
    # otherwise fetch
    else
        puts "Fetching shelves..."
        shelves = fetchShelves()
        shelves_doc.set(shelves)
        return shelves
    end
end

fetchShelvesOrUseCache(bust: true)