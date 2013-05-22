require 'bundler/setup'
require 'sinatra'
require 'redis'


before do
  key = "ratelimit:#{Time.now.to_f}"

  @redis = Redis.new host: 'localhost', port: 6379
  @redis.set key, 1
  @redis.expire key, 5
  list  = @redis.keys 'ratelimit:*'

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
  else
    status 403
  end
end
