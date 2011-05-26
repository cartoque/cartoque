module WelcomeHelper
  def welcome_box(html = "", &block)
    content_tag :div, :class => "grid_3" do
      content_tag :div, :class => "welcome-box" do
        if block_given?
          capture(&block)
        else
          html
        end
      end
    end
  end
end
