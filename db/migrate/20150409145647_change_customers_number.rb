class ChangeCustomersNumber < ActiveRecord::Migration
  change_table :customers do |t|
    t.rename :number, :room_number
  end
end
