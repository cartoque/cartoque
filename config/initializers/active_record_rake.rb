# This initializer establishes the connection with the MySQL database
# in case we want to run the migrations after the jump to Mongoid.
# Since ActiveRecord is no more required in config/application.rb, the
# connection was not set, hence the migrations not working.
#
# The trick is a bit ugly but I didn't manage to have the tasks working
# with just a rake task defined in lib/. So ...
if ARGV.first.match(/^db:/)
  env = Rails.env || 'development'
  config = Rails.application.config.database_configuration[env]
  ActiveRecord::Base.establish_connection(config)
end
