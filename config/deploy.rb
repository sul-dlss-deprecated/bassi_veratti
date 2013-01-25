require 'net/ssh/kerberos'
require 'bundler/setup'
require 'bundler/capistrano'
require 'dlss/capistrano'
require 'pathname'

set :stages, %W(staging development production)
set :default_stage, "staging"
set :bundle_flags, "--quiet"

set :sunet_id,   Capistrano::CLI.ui.ask('SUNetID: ') { |q| q.default =  `whoami`.chomp }
set :repository, "ssh://#{sunet_id}@corn.stanford.edu/afs/ir.stanford.edu/dev/dlss/git/digital_collection_sites/bassi_veratti.git"
set :deploy_via, :copy

require 'capistrano/ext/multistage'

set :shared_children, %w(
  log 
  config/database.yml
  config/solr.yml
)

set :user, "lyberadmin" 
set :runner, "lyberadmin"
set :ssh_options, {
  :auth_methods  => %w(gssapi-with-mic publickey hostbased),
  :forward_agent => true
}

set :destination, "/home/lyberadmin"
set :application, "bassi-lib"

set :scm, :git
set :copy_cache, true
set :copy_exclude, [".git"]
set :use_sudo, false
set :keep_releases, 3

set :deploy_to, "#{destination}/#{application}"

set :branch do
  DEFAULT_TAG = 'master'
  tag = Capistrano::CLI.ui.ask "Tag or branch to deploy (make sure to push the tag or branch first): [#{DEFAULT_TAG}] "
  tag = DEFAULT_TAG if tag.empty?
  tag
end

namespace :app do
  task :add_date_to_version do
    run "cd #{deploy_to}/current && date >> VERSION"
  end
  task :expire_caches do
    run "cd #{deploy_to}/current && rake bassi:expire_caches RAILS_ENV=#{rails_env}"
  end
end

namespace :jetty do
  task :config do
    run "cd #{deploy_to}/current && rake bassi:config RAILS_ENV=#{rails_env}"
  end
  task :start do 
    run "cd #{deploy_to}/current && rake jetty:start RAILS_ENV=#{rails_env}"
  end
  task :stop do
    run "if [ -d #{deploy_to}/current ]; then cd #{deploy_to}/current && rake jetty:stop RAILS_ENV=#{rails_env}; fi"
  end
  task :ingest_fixtures do
    run "cd #{deploy_to}/current && rake bassi:index_fixtures RAILS_ENV=#{rails_env}"
  end
end

namespace :db do
  task :migrate do
    run "cd #{deploy_to}/current && rake db:migrate RAILS_ENV=#{rails_env}"
  end
  task :loadfixtures do
    run "cd #{deploy_to}/current && rake db:fixtures:load RAILS_ENV=#{rails_env}"
  end
  task :symlink_sqlite do
    run "ln -fs #{shared_path}/#{rails_env}.sqlite3 #{release_path}/db/#{rails_env}.sqlite3"
  end  
end

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

after "deploy", "db:migrate"
after "deploy", "app:expire_caches"
after "deploy", "app:add_date_to_version"
