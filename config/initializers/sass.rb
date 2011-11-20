#see: http://metaskills.net/2011/05/18/use-compass-sass-framework-files-with-the-rails-3.1-asset-pipeline/
Sass::Engine::DEFAULT_OPTIONS[:load_paths].tap do |load_paths|
  load_paths << "#{Rails.root}/app/assets/stylesheets"
  #load_paths << "#{Gem.loaded_specs['compass'].full_gem_path}/frameworks/compass/stylesheets"
end
