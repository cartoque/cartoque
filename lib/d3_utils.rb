class D3Utils
  def initialize
    raise "This shouldn't be instantiated"
  end

  class << self
    # Transforms { a => { b => { c => 1, d => 2 } } }
    # In stringified version of { name: a, children: [ { name: b, children: [ { name: c, size: 1}, { name: d, size: 2 }] } ] }
    def hash_to_d3format(hash)
      hash.inject([]) do |memo, (key, value)|
        hsh = { "name" => key.to_s }
        case value
        when Integer, Fixnum, String
          hsh["size"] = value
        when Hash
          if value["name"].is_a?(String) && value["children"].is_a?(Array)
            hsh["children"] = [ value ]
          else
            hsh["children"] = hash_to_d3format(value)
          end
        when Array #already parsed / transformed
          hsh["children"] = value
        else
          raise "Malformed input, this shouldn't happen! Input was a #{value.class} => #{value}"
        end
        memo << hsh
      end
    end
  end
end
