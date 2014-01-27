module Tt
  def self.ttr_ls
    Slip.where(:stop => nil).each do |s|
      total_time, num_valid_slips = Tt::count_slips(s.timesheet)
    
      total_time_str = num_valid_slips ? " (+#{Tt::readable_time(total_time)} on #{num_valid_slips} completed slips)" : ""
      desc = s.timesheet.description ? " (#{s.timesheet.description})" : ""
      puts "#{Tt::readable_time(Time.now - s.start)} on timesheet #{s.timesheet.id}#{desc}#{total_time_str}"
    end
    if Slip.where(:stop => nil).count == 0
      puts "No open slips."
    end
  end
  
  def self.ttr_start(id, silence_output = false)
    if id
      ts = Timesheet.find_by_id(id)
    else
      ts = Timesheet.create
    end
    
    slip = Slip.create
    slip.timesheet_id = ts.id
    slip.start = Time.now
    slip.save
    
    puts "Started slip at #{slip.start} for timesheet #{ts.id}" unless silence_output
  end
end
