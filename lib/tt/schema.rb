class Schema < ActiveRecord::Migration
  def create
    ActiveRecord::Migration.verbose = false

    create_table :timesheets do |t|
      t.string   :description
    end
    
    create_table :slips do |t|
      t.integer  :timesheet_id
      t.datetime :start
      t.datetime :stop
    end
  end
end
