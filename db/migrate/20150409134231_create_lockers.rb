class CreateLockers < ActiveRecord::Migration
  def change
    create_table :lockers do |t|
      t.string     :number
      t.string     :size
      t.boolean    :assigned
      t.references :reservation

      t.timestamps
    end
    add_index :lockers, :number
    add_index :lockers, :reservation_id
  end
end
