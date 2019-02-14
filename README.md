# goodreads-api ✨

Tiny ruby server that exposes your Goodreads shelves with proper cover images. This is useful when creating a digital shelf for example.

## Requirements

- Ruby
- Redis

## Usage

Configure two environment variables:

```shell
export GOODREADS_API_KEY=<your_api_key>
export GOODREADS_USER_ID=<your_user_id>
```
Get an api key [here](https://www.goodreads.com/api/keys). User id is visible in your profile link.

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