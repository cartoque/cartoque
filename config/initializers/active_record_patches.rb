# This patch fixes a bad order bug in AR::Migration::CommandRecorder#invert_rename_index
# See https://github.com/rails/rails/pull/2716 for more information
# TODO: remove it when the pull request is merged into a stable branch
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
