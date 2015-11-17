# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'

require 'rspec/core/rake_task'
 
RSpec::Core::RakeTask.new(:spec) do |t|
	t.pattern = Dir.glob('spec/**/*_spec.rb')
	#t.rspec_opts = '--format documentation'
	# t.rspec_opts << ' more options'
	t.rcov = false
end

task :default => :spec

Cartoque::Application.load_tasks
