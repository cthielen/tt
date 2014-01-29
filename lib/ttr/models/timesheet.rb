class Timesheet < ActiveRecord::Base
  has_many :slips, :dependent => :destroy
end
