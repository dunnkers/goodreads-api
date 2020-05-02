# goodreads-api ✨

Tiny ruby server that exposes your Goodreads shelves with proper cover images. This is useful when creating a digital shelf for example.

## Requirements

- Ruby
- Redis

## Usage

1. Configure two environment variables:

```shell
export GOODREADS_API_KEY=<your_api_key>
export GOODREADS_USER_ID=<your_user_id>
```
Get an api key [here](https://www.goodreads.com/api/keys). User id is visible in your profile link.

2. Install dependencies:

```shell
bundle install
```

(make sure Gemfile and system Ruby versions match)

3. Run redis
Make sure Redis is running.

e.g. MacOS:
```shell
brew install redis
redis-server
```

4. Start the Sinatra server:

```shell
ruby app.rb
```

Visit [http://localhost:4567/](http://localhost:4567/) 💎

To force re-grabbing the cover images:

```shell
rake fetch
```

## Architecture

Links to cover images are found by crawling each book Goodreads page and processing it with nokogiri. These links are then stored in a Redis db and are then retrieved again by the server.

## Deployment

You can deploy easily on any platform desired - just setup a Ruby environment and make sure a Redis instance is running in the network. Its connection parameters are at default. Also make sure to set the environment variables. Feel free to build a Dockerfile with the required setup.

Out of the box, however, Heroku deployment works well. Just launch an app with the heroku/ruby buildpack, and install the Heroku Redis add-on. You can use Heroku Scheduler to periodically fetch new data; configure the job to execute `rake fetch`. Cheers!

## About

Built by [dunnkers](https://github.com/dunnkers) ⚡️