# This patch silences deface in logs until I have the time
# to propose a clean patch upstream in the deface project
require 'active_support/buffered_logger'

module ActiveSupport
  class BufferedLogger
    def add_with_deface_silenced(severity, message = nil, progname = nil, &block)
      unless message && message.start_with?("\e[1;32mDeface:")
        add_without_deface_silenced(severity, message, progname, &block)
      end
    end
    alias_method_chain :add, :deface_silenced
  end
end
