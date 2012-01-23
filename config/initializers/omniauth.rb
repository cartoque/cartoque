require 'omniauth/cas'

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

# configures public url for our application
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

# patch for v0.0.3
module OmniAuth
  module Strategies
    class CAS
      def return_url
        if request.params and request.params['url']
          {}
        else
          { :url => Rack::Utils.escape(request.referer) }
        end
      end
    end
  end
end

# patch to accept path (subdir) in cas_host
module OmniAuth
  module Strategies
    class CAS
      option :path, nil

      def cas_host_with_path
        @cas_host ||= cas_host_without_path + @options.path.to_s
      end
      alias_method_chain :cas_host, :path
    end
  end
end
