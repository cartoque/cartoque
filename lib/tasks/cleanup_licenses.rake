desc "Cleanup invalid licenses"
namespace :cleanup do
  task :licenses => :environment do
    License.all.each do |license|
      license.destroy if !license.valid?
    end
  end
end
