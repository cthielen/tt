class Timesheet < ActiveRecord::Base
  has_many :slips, :dependent => :destroy
  
  def to_s
    total_time, num_valid_slips = Ttr::count_slips(self)
    
    desc = self.description ? " (#{self.description})" : ""
    "#{Ttr::readable_time(total_time)} on #{num_valid_slips} slip(s) on timesheet #{self.id}#{desc}"
  end
end
