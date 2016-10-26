begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:rspec) do |spec|
    # spec.pattern = ['spec/integration/home_page_spec.rb:2']
  end
rescue LoadError
  desc 'rspec rake task not available (rspec not installed)'
  task :rspec do
    abort 'Rspec rake task is not available. Be sure to install rspec as a gem or plugin'
  end
end

desc 'Alias for rspec'
task :spec => 'rspec'
