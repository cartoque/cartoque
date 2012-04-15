source 'http://rubygems.org'

gem 'rails', '3.2.3'
gem 'rake'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# Debugging
gem 'log_buddy'

# Bundle the extra gems:
# gem 'bj'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
# group :development, :test do
#   gem 'webrat'
# end

# Rails 3.1's asset pipeline
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
gem 'yaml_db'
gem 'pdfkit', '0.5.2'
gem 'storcs', '>= 0.0.2'
gem 'omniauth', '>= 1.0.0'
gem 'omniauth-cas', '>= 0.0.6'
gem 'devise', '~> 2.0.0'
gem 'hashie'
gem 'nokogiri'
gem 'draper'
gem 'deface'
gem 'rabl', '>= 0.5.3'
gem 'acts_as_list'
gem 'mongoid'
gem 'bson_ext'
gem 'mongoid-ancestry'
gem 'mongoid_rails_migrations'
gem 'bootstrap-sass'
gem 'font-awesome-sass-rails'

# Plugins/engines
Dir.glob(File.expand_path("../vendor/plugins/*/Gemfile",__FILE__)).each do |gemfile|
  instance_eval File.read(gemfile)
end

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

group :development, :test do
  gem 'pry'
  gem 'i18n-verify'
end
