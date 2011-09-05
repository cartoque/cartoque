require 'omniauth/enterprise'

setup_app = Proc.new do |env|
  config = OmniAuth::Strategies::CAS::Configuration.new(:cas_server => Settler.safe_cas_server)
  env['omniauth.strategy'].instance_variable_set(:@configuration, config)
end
Rails.application.config.middleware.use OmniAuth::Strategies::CAS, :cas_server => "http://localhost:9292", :setup => setup_app


OmniAuth.config.full_host = Proc.new do |env|
  url = env["rack.session"]["omniauth.origin"] || env["omniauth.origin"]
  #if no url found, fall back to config/app_config.yml addresses
  if url.blank?
    url = "http://#{APP_CONFIG[:domain]}"
  #else, parse it and remove both request_uri and query_string
  else
    uri = URI.parse(url)
    url = "#{uri.scheme}://#{uri.host}"
    url << ":#{uri.port}" unless uri.default_port == uri.port
  end
  url
end
