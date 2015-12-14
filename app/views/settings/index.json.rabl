object false
node('application') { Cartoque.to_s } 
node('version') { Cartoque::VERSION } 
node('RUBY') { "#{RUBY_VERSION}-p#{RUBY_PATCHLEVEL} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}]" } 
node('RAILS') { Rails::VERSION::STRING } 
node('RAILS_ENV') { Rails.env }
node('Database') { attributes :mongodb => Mongoid.sessions }

node('setting') do {
	:cas_server => Setting.cas_server, 
	:site_announcement_message => Setting.site_announcement_message,
	:site_announcement_type => Setting.site_announcement_type,
	:site_announcement_updated_at => Setting.site_announcement_updated_at,
	:redmine_url => Setting.redmine_url,
	:dns_domains => Setting.dns_domains,
	:allow_internal_authentication => Setting.allow_internal_authentication
}
end
