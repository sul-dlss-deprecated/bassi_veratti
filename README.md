# Bassi Veratti Collection

[![Build Status](https://travis-ci.org/sul-dlss/bassi_veratti.svg?branch=master)](https://travis-ci.org/sul-dlss/bassi_veratti) [![Dependency Status](https://gemnasium.com/sul-dlss/bassi_veratti.svg)](https://gemnasium.com/sul-dlss/bassi_veratti) [![Coverage Status](https://coveralls.io/repos/github/sul-dlss/bassi_veratti/badge.svg?branch=master)](https://coveralls.io/github/sul-dlss/bassi_veratti?branch=master)

This is a Blacklight application for the Bassi Veratti Collection at Stanford University.

## Getting Started

Note that rake/rails calls may need to be prefixed with `bundle exec`.

### Checkout the code
```bash
git clone git@github.com:sul-dlss/bassi_veratti.git
cd bassi_veratti
git submodule update --init
```

### [Optional] If you want to use rvmrc to manage gemsets, copy the example file:
```bash
cp .rvmrc.example .rvmrc
```

### Install dependencies and migrate database:
```bash
bundle install
rake db:migrate db:seed
rake db:migrate db:seed RAILS_ENV=test
```

### Set up, configure and start local jetty
Stop any other jetty instances that might conflict, then:
```bash
rake jetty:clean bassi:config jetty:start
```

### Load the fixtures
Note: loading fixtures may take some time
```bash
rake bassi:index_fixtures
```

### Start Rails and Access App.:
```bash
rails s
```

Then browse to <http://localhost:3000>.

## Deployment
```bash
cap production deploy  # for production
cap staging deploy     # for staging
cap development deploy # for development
```

You must specify a branch or tag to deploy.  You can deploy the latest by specifying `master`.

## Testing

You can run the test suite locally by running:

```bash
rake local_ci
```

This will stop development jetty, force you into the test environment, start jetty, start solr,
delete all the records in the test solr core, index all fixtures in `spec/fixtures`, run `db:migrate` in test,
then run the tests, and then restart development jetty.

## Caching

The map on the home page and the collection inventory page are stored in a fragment cache to speed up delivery.  
Caching is currently enabled in all environments (including development) and stored on disk in the tmp folder of the app.
Fragment caches should be automatically purged on an EAD re-index or deployment via the following rake task (which
can be run manually if needed):

```bash
rake bassi:expire_caches
```

## Collection Highlights

The collection highlights shown on the home page are stored in MySQL.  The database entries are created in `db/seeds.rb`.
For each collection highlight, you need a name in English and Italian, a local placeholder image to show (placed in the `assets/image` folder), and a description (not shown).
You also need a list of IDs that belong in the collection.

## Utils

To reset jetty and solr back to an initial state:

```bash
rake jetty:clean
```
