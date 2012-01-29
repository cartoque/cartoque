require 'omniauth/cas'

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
