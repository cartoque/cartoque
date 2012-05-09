# Loads the core plugins located in RAILS_ROOT/plugins
# The code is strongly inspired from Redmine core and railties-3.2.3/lib/rails/plugin.rb

Dir.glob(File.join(Rails.root, "plugins/*")).sort.each do |directory|
  next unless File.directory?(directory)
  lib = File.join(directory, "lib")
  if File.directory?(lib)
    $:.unshift lib
    ActiveSupport::Dependencies.autoload_paths += [lib]
  end
  initializer = File.join(directory, "init.rb")
  if File.file?(initializer)
    # This double assignment is to prevent an "unused variable" warning on Ruby 1.9.3.
    config = config = Cartoque::Application.config
    eval(File.read(initializer), binding, initializer)
  end
end
