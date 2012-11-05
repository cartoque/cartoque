class Setting
  include Mongoid::Document

  field :cas_server, type: String, default: 'http://localhost:9292'
  field :site_announcement_message, type: String
  field :site_announcement_type, type: String
  field :site_announcement_updated_at, type: DateTime
  field :redmine_url, type: String, default: ''
  field :dns_domains, type: String, default: ''
  field :allow_internal_authentication, type: String, default: 'yes'

  class << self
    def instance
      Thread.current[:setting_instance] ||= (first || create!)
    end

    def safe_cas_server
      self.cas_server.strip.presence || "http://localhost:9292"
    end

    def method_missing(method_name, *args)
      instance.send(method_name, *args)
    end
  end
end
