require 'omniauth/patches'
require 'omniauth/dynamic_full_host'

# a setup app that handles dynamic config of CAS server
setup_app = Proc.new do |env|
  cas_server = URI.parse(Settler.safe_cas_server) rescue nil
  if cas_server
    env['omniauth.strategy'].options.merge! :host => cas_server.host,
                                            :port => cas_server.port,
                                            :path => (cas_server.path != "/" ? cas_server.path : nil),
                                            :ssl  => cas_server.scheme == "https"
  end
end

# tell Rails we use this middleware, with some default value just in case
Rails.application.config.middleware.use OmniAuth::Strategies::CAS, :host => "localhost",
                                                                   :port => "9292",
                                                                   :ssl => false,
                                                                   :setup => setup_app
