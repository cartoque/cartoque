# These helper methods can be called in your template to set variables to be used in the layout
# This module should be included in all views globally,
# to do so you may need to add this line to your ApplicationController
#   helper :layout
module LayoutHelper
  def title(page_title, show_title = true)
    content_for(:title) { page_title.to_s }
    @show_title = show_title
  end

  def show_title?
    @show_title
  end

  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args) }
  end

  def javascript(*args)
    content_for(:head) { javascript_include_tag(*args) }
  end

  def details_box(title, options = {}, &block)
    content_tag :div, style: options[:style] do
      content_tag(:span, (title.is_a?(Symbol) ? t(title) : title), class: 'label') +
        content_tag(:div, class: 'details') do
          capture(&block) if block_given?
        end
    end
  end
end
