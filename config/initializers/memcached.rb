#see: https://gist.github.com/153560
begin
  # check if memcached is running; if it is, use that instead of the default memory cache
  Timeout.timeout(0.5) { TCPSocket.open("localhost", 11211) { } }
  Rails.application.config.cache_store = :mem_cache_store, %w(localhost:11211), { :namespace => Rails.application.engine_name, :timeout => 60 }
  puts "=> Cache: using memcached on localhost:11211"
rescue StandardError
  Rails.application.config.cache_store = nil
  puts "=> Cache: memcached not running, caching to memory"
end
