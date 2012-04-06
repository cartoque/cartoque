#some useful nanoc helpers
include Nanoc3::Helpers::Rendering
include Nanoc3::Helpers::LinkTo

#ours
require 'json'
module Cartoque
  module NanocHelpers
    def json_block(&block)
      raise "Gimme a block" unless block_given?
      html = json_pretty(capture(&block).strip)
      html = %(<pre><code data-language="javascript">)+html+%(</code></pre>)
      buffer = eval('_erbout', block.binding)
      buffer << html
    end

    def json_pretty(json_string)
      JSON.pretty_generate(JSON.parse(json_string))
    end
  end
end
include Cartoque::NanocHelpers
