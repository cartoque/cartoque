desc "Clean up assets depending on missing files in data/*"
namespace :cleanup do
  task :all do
    Rake.application.tasks.select do |task|
      task.name.starts_with?("cleanup:") && task.name != "cleanup:all"
    end.each do |task|
      task.invoke
    end
  end
end
