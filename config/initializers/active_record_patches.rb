require 'active_record/migration/command_recorder'

module ActiveRecord
  class Migration
    class CommandRecorder
      def invert_rename_index(args)
        #[:rename_index, args.reverse]
        [:rename_index, [args.first] + args.last(2).reverse]
      end
    end
  end
end
