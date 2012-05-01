source 'http://rubygems.org'

# Core framework
gem 'rails', '3.2.3'
gem 'rake'

# Rails 3's asset pipeline
gem 'json'
gem 'sass-rails'
gem 'coffee-rails'
gem 'uglifier'
# JS Runtime
gem 'therubyracer'

# App's gems
gem 'inherited_resources'
gem 'simple_form', '~> 1.5.2'
gem 'show_for'
gem 'has_scope'
gem 'jquery-rails', '>= 1.0.12'
gem 'pdfkit', '0.5.2'
gem 'storcs', '>= 0.0.2'
gem 'hashie'
gem 'nokogiri'
gem 'draper'
gem 'deface', '= 0.7.2'
gem 'rabl', '>= 0.5.3'
# Mongo / data manipulation
gem 'mongoid'
gem 'bson_ext'
gem 'mongoid-ancestry'
gem 'mongoid_rails_migrations'
#TODO: use the gem instead of our version in lib/ when fixes are merged in master
#gem 'mongoid_denormalize'
# Styles
gem 'bootstrap-sass'
gem 'font-awesome-sass-rails'
gem 'lograge'
# Authentication
gem 'omniauth', '>= 1.0.0'
gem 'omniauth-cas', '>= 0.0.6'
gem 'devise', '~> 2.0.0'

# Plugins/engines
Dir.glob(File.expand_path("../vendor/plugins/*/Gemfile",__FILE__)).each do |gemfile|
  instance_eval File.read(gemfile)
end

# Debugging tools
gem 'log_buddy'
group :development, :test do
  gem 'quiet_assets'
  gem 'pry'
  gem 'i18n-verify'
end

# Tests
group :test do
  gem 'factory_girl_rails', '~> 3.0'
  gem 'database_cleaner'
  gem 'guard-rspec'
  gem 'spork', '> 0.9.0.rc'
  gem 'guard-spork'
  gem 'libnotify'
  gem 'rb-inotify'
  # the cover_me gem is not compatible with rbx and jruby
  # but only need this on one environment...
  gem 'cover_me', :platforms => :mri_19
  gem 'rspec'
  gem 'rspec-rails'
  gem 'capybara'
end
