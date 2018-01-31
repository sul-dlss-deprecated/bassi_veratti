# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
BassiVeratti::Application.initialize!

BassiVeratti::Application.config.purl = "https://purl.stanford.edu"
