require 'bundler/setup'
require 'sinatra'
require 'redis'


configure do
  REDIS = Redis.new host: 'localhost', port: 6379
end

before do
  key = "ratelimit:#{Time.now.to_f}"

  REDIS.set key, 1
  REDIS.expire key, 5
  list  = REDIS.keys 'ratelimit:*'

  status 429 and halt if list.length > 10
end

get '/' do
  status 200

  body <<-HTML
  <form method="post">
    <input name="guess" placeholder="Last 4">
    <input type="submit" value="Guess">
  </form>
  HTML
end

post '/' do
  if params[:guess].downcase == 'gpcn'
    status 202
    body <<-HTML
      <meta http-equiv="refresh" content="3; url=https://www.google.com/search?site=imghp&tbm=isch&q=you+win+gif">
      <h1><h1>you win!</h1></h1>
    HTML
  else
    status 403
    body 'nope'
  end
end
