require 'database_cleaner/moped/truncation'

module DatabaseCleaner
  module Moped
    module Truncation
      private
      def collections
        session['system.namespaces'].find(:name => { '$not' => /^system|\$/ }).to_a.map do |collection|
          _, name = collection['name'].split('.', 2)
          name
        end
      end

    end
  end
end
