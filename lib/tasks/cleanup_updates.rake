desc "Cleanup upgrade tasks older than 10 days"
namespace :cleanup do
  task :updates => :environment do
    #don't run if there's no new upgrade (maybe import/cleanup tasks are broken)
    if Upgrade.where(:updated_at.gt => Date.today - 1.day).count > 0
      Upgrade.where(:updated_at.lt => Date.today - 10.days).destroy_all
    end
  end
end
