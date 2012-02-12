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
