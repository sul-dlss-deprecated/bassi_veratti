server 'sul-bv-dev.stanford.edu', user: 'bv', roles: %w(web db app)

Capistrano::OneTimeKey.generate_one_time_key!
set :rails_env, "development"
