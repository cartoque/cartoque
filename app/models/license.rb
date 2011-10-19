class License < ActiveRecord::Base
  has_and_belongs_to_many :servers

  scope :by_editor, proc {|editor| where(:editor => editor) }
  scope :by_key, proc { |search| where("key LIKE ?", "%#{search}%") }
  scope :by_title, proc { |search| where("title LIKE ?", "%#{search}%") }
  scope :by_server, proc { |id| joins(:servers).where("servers.id" => id) }
end
