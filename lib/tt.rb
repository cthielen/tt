require "tt/version"

Bundler.require(:default)

module Tt
  TT_DIR = ENV['TT_DIR'] ? ENV['TT_DIR'] : "#{Dir.home}/.tt/"

  # Ensure rdvr data directory exists
  `mkdir #{TT_DIR} >& /dev/null`
  
  # duration - in seconds
  def self.readable_time(duration)
    if duration < 60
      return "#{duration.to_i}s"
    end
    if duration < 3600
      return "#{(duration / 60).to_i}m #{(duration % 60).to_i}s"
    end
  end
  
  def self.count_slips(timesheet)
    total_time = 0
    num_valid_slips = 0
    timesheet.slips.each do |s|
      if s.stop
        total_time = total_time + (s.stop - s.start)
        num_valid_slips = num_valid_slips + 1
      end
    end
    
    return total_time, num_valid_slips
  end
end

# Load supporting code and models
require "tt/database"
require "tt/models/timesheet"
require "tt/models/slip"
require "tt/which.rb"
require "tt/schema.rb"
