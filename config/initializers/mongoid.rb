# See: http://blog.noizeramp.com/2010/12/21/friendly-composite-keys-in-mongoid/
# String#identify is used when the `key` macro is defined in a model

# Instead of the standard composition, convert everything
# non-alpha and non-digit to dash and squeeze
class String
  def identify
    if Mongoid.parameterize_keys
      downcase.gsub(/[^a-z0-9]+/, ' ').strip.gsub(' ', '-')
    else
      self
    end
  end
end

# Regexp convenience method to define search masks
class Regexp
  # Regexp.mask("blah") = /blah/i + with regexp escaping
  def self.mask(pattern)
    Regexp.new(Regexp.escape(pattern), Regexp::IGNORECASE)
  end
end
