desc "Imports every assets from files in data/*"
namespace :import do
  task :all do
    Rake.application.tasks.select do |task|
      task.name.starts_with?("import:") && task.name != "import:all"
    end.each do |task|
      task.invoke
    end
  end
end
