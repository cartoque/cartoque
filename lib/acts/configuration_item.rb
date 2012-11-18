module Acts
  module ConfigurationItem
    extend ActiveSupport::Concern

    # Exception raised when prerequisites are not met
    class MissingPrerequisite < StandardError; end

    included do
      raise MissingPrerequisite, "missing has_and_belongs_to_many method" unless respond_to?(:has_and_belongs_to_many)
      raise MissingPrerequisite, "missing default_scope method" unless respond_to?(:default_scope)

      # stores the datacenter(s) for this specific collection 
      has_and_belongs_to_many :datacenters, autosave: true

      # scopes all queries to current user if present
      # see ApplicationController#scope_current_user around filter
      default_scope lambda {
        if User.current.present?
          scoped.or({ :datacenter_ids.in => User.current.visible_datacenter_ids },
                    { :datacenter_ids.with_size => 0 })
        else
          scoped
        end
      }
    end
  end
end
