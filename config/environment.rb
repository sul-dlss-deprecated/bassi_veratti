# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
BassiVeratti::Application.initialize!

BassiVeratti::Application.config.purl_plugin_server = "prod"
BassiVeratti::Application.config.purl_plugin_location = "//image-viewer.stanford.edu/assets/purl_embed_jquery_plugin.js"
BassiVeratti::Application.config.purl = "http://purl.stanford.edu"