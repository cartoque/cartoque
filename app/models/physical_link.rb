class PhysicalLink < ActiveRecord::Base
  belongs_to :server
  belongs_to :switch, :class_name => 'Server'

  validates_inclusion_of :link_type, :in => %w(eth fc)

  def to_s
    html = %(<span class="link-#{link_type}">#{server_label || link_type}</span> &rarr; )
    html << %(#{helpers.link_to switch.name, "/servers/#{switch.id}"} #{switch_label})
    html.html_safe
  end

  def helpers
    ActionController::Base.helpers
  end
end
