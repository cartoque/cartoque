ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'application_controller'
class ApplicationController
  def current_user
    User.new
  end
end

require 'server'
class Server
  def postgres_file
    File.expand_path("../data/postgres/#{name.downcase}.txt", __FILE__)
  end

  def oracle_file
    File.expand_path("../data/oracle/#{name.downcase}.txt", __FILE__)
  end
end

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  #fixtures :all

  # Add more helper methods to be used by all tests here...
end
