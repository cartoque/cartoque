#some useful nanoc helpers
include Nanoc3::Helpers::Rendering
include Nanoc3::Helpers::LinkTo

#ours
require 'json'
module Cartoque
  module NanocHelpers
    def json_pretty(json_string)
      JSON.pretty_generate(JSON.parse(json_string))
    end
  end
end
include Cartoque::NanocHelpers
