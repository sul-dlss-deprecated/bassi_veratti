set :rails_env, "development"
set :deployment_host, "bv-dev.stanford.edu"
set :bundle_without, [:deployment]

set :git_enable_submodules, 1

role :web, deployment_host
role :app, deployment_host
role :db,  deployment_host, :primary => true

namespace :deploy do
  namespace :assets do
    task :symlink do ; end
    task :precompile do ; end
  end
end

before "deploy", "jetty:stop"
before "deploy:migrate", "db:symlink_sqlite"
before "deploy:migrate", "jetty:config"
after "deploy", "jetty:start"
after "deploy", "db:loadfixtures"
after "jetty:start", "jetty:ingest_fixtures"