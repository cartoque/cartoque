#temporary backport of https://github.com/rails/rails/commit/63d3809e31cc9c0ed3b2e30617310407ae614fd4
#to silence stupid sprockets warnings on deprecated methods

require 'sprockets/helpers/rails_helper'

module Sprockets
  module Helpers
    module RailsHelper
      class AssetPaths
        def digest_for(logical_path)
          if asset = asset_environment[logical_path]
            return asset.digest_path
          end

          logical_path
        end

        def rewrite_asset_path(source, dir)
          if source[0] == ?/
            source
          else
            source = digest_for(source) if performing_caching?
            source = File.join(dir, source)
            source = "/#{url}" unless source =~ /^\//
            source
          end
        end
      end
    end
  end
end
