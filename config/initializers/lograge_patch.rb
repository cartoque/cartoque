# Basic monkey patch to avoid type cast errors with passenger
# See: https://github.com/mattmatt/lograge/pull/5
# TODO: remove it when it's fixed in a stable lograge version

require 'lograge/log_subscriber'

module Lograge
  class RequestLogSubscriber
    def extract_status(payload)
      if payload[:status]
        " status=#{payload[:status]}"
      elsif payload[:exception]
        exception, message = payload[:exception]
        " status=500 error='#{exception}:#{message}'"
      else
        " status=unknown"
      end
    end
  end
end
