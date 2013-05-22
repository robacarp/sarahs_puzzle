require 'bundler/setup'
require 'sinatra'
require 'redis'

@redis = Redis.new host: 'localhost', port: 6379

key = "ratelimit:#{Time.now.to_f}"
@redis.set key, 1
@redis.expire key, 5
list  = @redis.keys 'ratelimit:*'

def limited
  status 429
end

get '/' do
  limited and return if list.length > 10
  status 200

  body <<-HTML
  <form method="post">
    <input name="guess" placeholder="Last 4">
    <input type="submit" value="Guess">
  </form>
  HTML
end

post '/' do
  limited and return if list.length > 10
  if params[:guess].downcase == 'gpcn'
    status 202
  else
    status 403
  end
end
