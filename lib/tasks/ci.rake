require 'jettywrapper'
require 'rest_client'

desc "Run continuous integration suite"
task :ci do
  unless Rails.env.test?  
    system("rake ci RAILS_ENV=test")
  else
    Jettywrapper.wrap(Jettywrapper.load_config) do
      Rake::Task["bassi:refresh_fixtures"].invoke
      Rake::Task["rspec"].invoke
    end
  end
end

desc "Stop dev jetty, run `rake ci`, start dev jetty."
task :local_ci do  
  system("rake jetty:stop")
  system("rake db:migrate RAILS_ENV=test")  
  system("rake jetty:start RAILS_ENV=test")
  system("rake bassi:refresh_fixtures RAILS_ENV=test")
  system("rspec")
  system("rake jetty:stop RAILS_ENV=test")  
  system("rake jetty:start")
end


namespace :bassi do

  desc "restore jetty to initial state"
  task :jetty_nuke do
    puts "Nuking jetty"
    # Restore jetty submodule to initial state.
    Rake::Task['jetty:stop'].invoke
    Dir.chdir('jetty') {
      system('git reset --hard HEAD') or exit
      system('git clean -dfx')        or exit
    }
    Rake::Task['bassi:jetty_config'].invoke
    Rake::Task['jetty:start'].invoke
  end
  
  desc "Setup the bassi jetty instance by coping solr config files into the right place"
  task :jetty_config do
    app_root=File.expand_path('../../../', __FILE__)
    FileUtils.cp File.join(app_root,'solr_conf','solr.xml'),File.join(app_root,'jetty','solr')
    FileUtils.cp File.join(app_root,'solr_conf','conf','schema.xml'),File.join(app_root,'jetty','solr','blacklight-core','conf')
    FileUtils.cp File.join(app_root,'solr_conf','conf','solrconfig.xml'),File.join(app_root,'jetty','solr','blacklight-core','conf')
  end
  
  desc "Delete and index all fixtures in solr"
  task :refresh_fixtures do
    Rake::Task["bassi:delete_records_in_solr"].invoke
    Rake::Task["bassi:index_fixtures"].invoke
  end
  
  desc "Index all fixutres into solr"
  task :index_fixtures do
    add_docs = []
    Dir.glob("#{Rails.root}/spec/fixtures/*.xml") do |file|
      add_docs << File.read(file)
    end
    puts "Adding #{add_docs.count} documents to #{Blacklight.solr.options[:url]}"
    RestClient.post "#{Blacklight.solr.options[:url]}/update?commit=true", "<update><add>#{add_docs.join(" ")}</add></update>", :content_type => "text/xml"
  end
  
  desc "Delete all records in solr"
  task :delete_records_in_solr do
   unless Rails.env.production?
      puts "Deleting all solr documents from #{Blacklight.solr.options[:url]}"
      RestClient.post "#{Blacklight.solr.options[:url]}/update?commit=true", "<delete><query>*:*</query></delete>" , :content_type => "text/xml"
    else
      puts "Did not delete since we're running under the #{Rails.env} environment and not under test. You know, for safety."
    end
  end
end