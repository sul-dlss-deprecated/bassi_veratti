require 'solr_wrapper' unless Rails.env.production? || Rails.env.staging?
require 'rest_client'

desc "Run continuous integration suite"
task :ci => ['bassi:config', 'db:migrate'] do
  if Rails.env.test?
    SolrWrapper.wrap do |solr|
      solr.with_collection do
        Rake::Task['bassi:index_fixtures'].invoke unless ENV['SKIP_FIXTURES']

        # run the tests
        Rake::Task["rspec"].invoke
      end
    end
  else
    system("rake ci RAILS_ENV=test")
  end
end

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
  end

  desc "Index all fixutres into solr"
  task :index_fixtures => ['bassi:parse-ead', 'bassi:expire_caches']
end
