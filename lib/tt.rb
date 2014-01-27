# require 'bundler'
# 
# Bundler.require(:default)

require 'tt/version'

module Tt
  TT_DIR = ENV['TT_DIR'] ? ENV['TT_DIR'] : "#{Dir.home}/.tt/"

  # Ensure data directory exists
  `mkdir #{TT_DIR} >& /dev/null`
  
  # duration - in seconds
  def self.readable_time(duration)
    # Credit: http://stackoverflow.com/questions/1679266/can-ruby-print-out-time-difference-duration-readily
    secs  = duration.to_int
    mins  = secs / 60
    hours = mins / 60
    days  = hours / 24

    if days > 0
      return "#{days}d #{hours % 24}h"
    elsif hours > 0
      return "#{hours}h #{mins % 60}m"
    elsif mins > 0
      return "#{mins}m #{secs % 60}s"
    elsif secs >= 0
      return "#{secs}s"
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
require "tt/commands.rb"
