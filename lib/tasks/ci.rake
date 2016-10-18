require 'jettywrapper' unless Rails.env.production? || Rails.env.staging?
require 'rest_client'

ZIP_URL = "https://github.com/projectblacklight/blacklight-jetty/archive/v4.0.0.zip"

desc "Run continuous integration suite"
task :ci => ['jetty:clean', 'bassi:config', 'db:migrate'] do
  if Rails.env.test?
    jetty_params = Jettywrapper.load_config
    jetty_params[:startup_wait] = 60
    Jettywrapper.wrap(jetty_params) do
      Rake::Task["bassi:refresh_fixtures"].invoke unless ENV['SKIP_FIXTURES']

      # run the tests
      Rake::Task["rspec"].invoke
    end
  else
    system("rake ci RAILS_ENV=test")
  end
end

desc "Stop dev jetty, run `rake ci`, start dev jetty."
task :local_ci => ['jetty:stop', 'ci', 'jetty:start']

namespace :bassi do
  desc "Expire caches"
  task :expire_caches => :environment do
    begin
      Rails.cache.clear
    rescue StandardError => e
      puts "Warning: #{e.message} -- no caching folder found"
    end
  end

  desc "Copy Bassi configuration files"
  task :config do
    cp("#{Rails.root}/config/database.yml.example", "#{Rails.root}/config/database.yml") unless File.exist?("#{Rails.root}/config/database.yml")
    cp("#{Rails.root}/config/solr.yml.example", "#{Rails.root}/config/solr.yml") unless File.exist?("#{Rails.root}/config/solr.yml")
    cp("#{Rails.root}/solr_conf/solr.xml", "#{Rails.root}/jetty/")
    cp("#{Rails.root}/solr_conf/conf/schema.xml", "#{Rails.root}/jetty/solr/blacklight-core/conf")
    cp("#{Rails.root}/solr_conf/conf/solrconfig.xml", "#{Rails.root}/jetty/solr/blacklight-core/conf")
  end

  desc "Delete and index all fixtures in solr"
  task :refresh_fixtures => ['bassi:delete_records_in_solr', 'bassi:index_fixtures']

  desc "Index all fixutres into solr"
  task :index_fixtures => ['bassi:parse-ead', 'bassi:expire_caches']

  desc "Delete all records in solr"
  task :delete_records_in_solr do
    if Rails.env.production?
      puts "Did not delete since we're running under the #{Rails.env} environment and not under test. You know, for safety."
    else
      Blacklight.solr.delete_by_query '*:*', commit: true
    end
  end
end
