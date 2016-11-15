require 'solr_wrapper' unless Rails.env.production?

desc "Run continuous integration suite"
task :ci => [:environment, 'solr:clean', 'bassi:config', 'db:migrate'] do
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
    %w(database solr).each do |stem|
      destination = "#{Rails.root}/config/database.yml"
      cp("#{destination}.example", destination, :verbose => true) unless File.exist?(destination)
    end
  end

  desc 'Delete and index all fixtures in solr'
  task :refresh_fixtures => [:environment, 'bassi:delete_records_in_solr', 'bassi:index_fixtures']

  desc 'Index all fixutres into solr'
  task :index_fixtures => [:environment, 'bassi:parse-ead', 'bassi:expire_caches']

  desc 'Delete all records in solr'
  task :delete_records_in_solr => :environment do
    if Rails.env.production?
      puts "Did not delete since we're running under the #{Rails.env} environment and not under test. You know, for safety."
    else
      Blacklight.default_index.connection.delete_by_query '*:*', commit: true
    end
  end
end
