module SizeHelper
  def display_size(size)
    html = size_in_Go(size)
    if html.to_f <= 1
      html = %(<abbr title="#{size_in_Mo(size)}Mo">#{html}</abbr>)
    end
    html.to_s.html_safe
  end

  def size_in_Go(size)
    "%.1f" % (size / 1024.0**3)
  end

  def size_in_Mo(size)
    "%.1f" % (size / 1024.0**2)
  end
end
