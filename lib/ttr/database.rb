require 'active_record'
require 'sqlite3'

ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :database => "#{Ttr::TTR_DIR}/db.sqlite"
)

unless File.exist?("#{Ttr::TTR_DIR}/db.sqlite")
  require File.dirname(__FILE__) + '/schema.rb'
  schema = Schema.new
  schema.create
end
