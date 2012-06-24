module Acts
  module Ipaddress
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def acts_as_ipaddress(options = {})
        raise "You must define attributes which will acts_as_ipaddress!" if options.blank?
        Array(options).each do |attr|
          class_eval <<-"SRC"
            def #{attr}
              IPAddr.new_from_int(read_attribute(:#{attr}))
            end

            def #{attr}=(value)
              raise "Can't write attribute since there is no '#{attr}' column" unless fields.keys.include?("#{attr}")
              if value == value.to_i.to_s && value.to_i <= 32 #netmask!
                value = IPAddr.new("255.255.255.255/"+value.to_s).to_s
              end
              if IPAddr.valid?(value)
                write_attribute(:#{attr}, IPAddr.new(value, Socket::AF_INET).to_i)
              else
                # $stderr.puts "Invalid address: "+value.to_s
              end
            end
          SRC
        end
      end
    end
  end
end
