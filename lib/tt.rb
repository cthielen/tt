Bundler.require(:default)

# Ensure rdvr data directory exists
`mkdir ~/.rdvr >& /dev/null`

# Load supporting code and models
require "rdvr/database"
require "rdvr/models/recording"
require "rdvr/models/show"
require "rdvr/which.rb"
require "rdvr/schema.rb"
