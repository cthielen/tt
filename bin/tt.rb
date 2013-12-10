#!/usr/bin/env ruby

# Time-tracker

require 'tt'

def print_help
  puts "Usage: tt <command>\n\nValid commands:"
  puts "\tls            - show currently running timesheets"
  puts "\tlog           - show timesheets with no currently running slips"
  puts "\tstart <N>     - start recording and use timesheet with ID N (creates a timesheet without N)"
  puts "\tstop <N>      - stop recording timesheet with ID N (defaults to most recent timesheet without N)"
  puts "\tdesc N <desc> - write a description for timesheet N"
  puts "\t<no command>  - show currently running timesheets"
end

unless ARGV.length >= 1
  print_help
  exit
end

case ARGV[0]
  when 'help'
    print_help
    exit
  when 'ls'
    Slip.where(:stop => nil).each do |s|
      desc = s.timesheet.description ? " (#{s.timesheet.description})" : ""
      puts "#{Tt::readable_time(Time.now - s.start)} on timesheet #{s.timesheet.id}#{desc}"
    end
    if Slip.where(:stop => nil).count == 0
      puts "No open slips."
    end
    exit
  when 'start'
    if ARGV[1]
      ts = Timesheet.find_by_id(ARGV[1])
    else
      ts = Timesheet.create
    end
    
    slip = Slip.create
    slip.timesheet_id = ts.id
    slip.start = Time.now
    slip.save
    
    puts "Started slip at #{slip.start} for timesheet #{ts.id}"
    exit
  when 'stop'
    if ARGV[1]
      ts = Timesheet.find_by_id(ARGV[1])
    else
      # No timesheet ID specified. Use last opened slip if available.
      s = Slip.where(:stop => nil).first
      ts = s.timesheet
      unless s
        puts "Couldn't find any open slips to stop."
        exit
      end
    end
    
    s = ts.slips.where(:stop => nil).first
    
    s.stop = Time.now
    s.save
    
    puts "Finished slip with #{Tt::readable_time(s.stop - s.start)} for timesheet #{ts.id}"
    exit
  when 'desc'
    if ARGV[1]
      ts = Timesheet.find_by_id(ARGV[1])
    else
      puts "You must specify a timesheet ID."
      exit
    end
    if ARGV[2]
      ts.description = ARGV[2]
      ts.save
      exit
    else
      puts "You must specify a description."
      exit
    end
  when 'log'
    Timesheet.all.each do |t|
      total_time, num_valid_slips = Tt::count_slips(t)
      
      desc = t.description ? " (#{t.description})" : ""
      puts "#{Tt::readable_time(total_time)} across #{num_valid_slips} slips on timesheet #{t.id}#{desc}"
    end
    if Timesheet.count == 0
      puts "No timesheets."
    end
    
    exit
  else
    puts "Unknown command.\n\n"
    print_help
    exit
end
