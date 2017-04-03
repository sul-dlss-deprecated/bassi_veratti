server 'sul-bv-prod.stanford.edu', user: 'bv', roles: %w(web db app)

Capistrano::OneTimeKey.generate_one_time_key!
set :rails_env, "production"
