# goodreads-api ✨

Tiny ruby server that exposes your Goodreads shelves with proper cover images. This is useful when creating a digital shelf for example.

## Requirements

- Ruby
- Redis

## Usage

Configure your 

To start the Sinatra server:

```shell
ruby app.rb
```

To force re-grabbing the cover images:

```shell
rake fetch
```

Make sure Redis is running.

## Architecture

Links to cover images are found by crawling each book Goodreads page and processing it with nokogiri. These links are then stored in a Redis db and are then retrieved again by the server.

## About

Built by [dunnkers](https://github.com/dunnkers) ⚡️