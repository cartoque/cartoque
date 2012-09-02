require 'rubygems'
require 'spork'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.

  #reload routes for devise
  require 'rails/application'
  Spork.trap_method(Rails::Application::RoutesReloader, :reload!)

  #reload mongoid models
  require 'rails/mongoid'
  Spork.trap_class_method(Rails::Mongoid, :load_models)

  # Coverage tool for ruby 1.9
  require 'cover_me' if File.exists?('/etc/debian_version')

  # This file is copied to spec/ when you run 'rails generate rspec:install'
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'capybara/rspec'
  require 'capybara/rails'
  require 'devise/test_helpers'

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  RSpec.configure do |config|
    # == Mock Framework
    #
    # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
    #
    # config.mock_with :mocha
    # config.mock_with :flexmock
    # config.mock_with :rr
    config.mock_with :rspec

    # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
    #config.fixture_path = "#{::Rails.root}/spec/fixtures"

    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    # instead of true.
    #config.use_transactional_fixtures = true

    # Config mode for OmniAuth
    #OmniAuth.config.test_mode = true
    #OmniAuth.config.mock_auth[:cas] = {
    #  'provider' => 'cas',
    #  'uid'      => create(:user).uid
    #}

    #a clean state between each spec/test
    config.before(:suite) do
      #DatabaseCleaner[:active_record].strategy = :transaction
      DatabaseCleaner[:mongoid].strategy = :truncation
      DatabaseCleaner.clean_with :truncation
    end

    config.before(:each) do
      DatabaseCleaner.start
    end

    config.after(:each) do
      DatabaseCleaner.clean
    end

    # a tiny patch to database_cleaner for moped adapter
    # it doesn't clean collections with 'system' in its name,
    # while it should only exclude collections beginning with 'system'
    require 'database_cleaner/moped_truncation_patch'

    # factory girl invocation methods
    config.include FactoryGirl::Syntax::Methods

    # include capybara matchers in decorator specs
    config.include Capybara::RSpecMatchers, type: :decorator

    # include devise helpers in controller specs
    config.include Devise::TestHelpers, type: :controller
    config.extend ControllerMacros, type: :controller

    # include warden helpers in integration specs
    config.include Warden::Test::Helpers, type: :request
  end
end

Spork.each_run do
  #ActiveSupport::Dependencies.clear
end
