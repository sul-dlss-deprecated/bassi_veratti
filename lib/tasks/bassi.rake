require 'solr_wrapper' unless Rails.env.production?
require 'rest_client'

desc "Run continuous integration suite"
task :ci => ['solr:clean', 'bassi:config', 'db:migrate'] do
  abort 'Refusing to run :ci in production' if Rails.env.production?
  SolrWrapper.wrap do |solr|
    solr.with_collection(dir: File.join(Rails.root, 'solr_conf/conf')) do
      Rake::Task['bassi:refresh_fixtures'].invoke unless ENV['SKIP_FIXTURES']
      Rake::Task['rspec'].invoke
    end
  end
end

namespace :bassi do
  desc 'Expire caches'
  task :expire_caches => :environment do
    begin
      Rails.cache.clear
    rescue StandardError => e
      puts "Warning: #{e.message} -- no caching folder found"
    end
  end

  desc 'Copy Bassi configuration files'
  task :config do
    cp("#{Rails.root}/config/database.yml.example", "#{Rails.root}/config/database.yml") unless File.exist?("#{Rails.root}/config/database.yml")
    cp("#{Rails.root}/config/solr.yml.example", "#{Rails.root}/config/solr.yml") unless File.exist?("#{Rails.root}/config/solr.yml")
    # cp("#{Rails.root}/solr_conf/solr.xml", "#{Rails.root}/solr/conf/")
    # cp("#{Rails.root}/solr_conf/conf/schema.xml", "#{Rails.root}/solr/conf/", :verbose => true)
    # cp("#{Rails.root}/solr_conf/conf/solrconfig.xml", "#{Rails.root}/solr/conf/", :verbose => true)
  end

  desc 'Delete and index all fixtures in solr'
  task :refresh_fixtures => ['bassi:delete_records_in_solr', 'bassi:index_fixtures']

  desc 'Index all fixutres into solr'
  task :index_fixtures => ['bassi:parse-ead', 'bassi:expire_caches']

  desc 'Delete all records in solr'
  task :delete_records_in_solr do
    if Rails.env.production?
      puts "Did not delete since we're running under the #{Rails.env} environment and not under test. You know, for safety."
    else
      Blacklight.default_index.connection.delete_by_query '*:*', commit: true
    end
  end
end
