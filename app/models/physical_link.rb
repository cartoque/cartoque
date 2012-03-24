class PhysicalLink
  include Mongoid::Document
  include Mongoid::Timestamps

  field :server_label, type: String
  field :switch_label, type: String
  field :link_type, type: String
  belongs_to :server, class_name: 'MongoServer', inverse_of: :physical_links
  belongs_to :switch, class_name: 'MongoServer', inverse_of: :connected_links

  validates_inclusion_of :link_type, in: %w(eth fc)

  def to_s
    html = %(<span class="link-#{link_type}">#{server_label || link_type}</span> &rarr; )
    html << %(#{helpers.link_to switch.name, "/servers/#{switch.id}"} #{switch_label})
    html.html_safe
  end

  def helpers
    ActionController::Base.helpers
  end
end
