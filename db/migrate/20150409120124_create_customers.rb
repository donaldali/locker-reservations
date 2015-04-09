class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string  :first_name
      t.string  :last_name
      t.string  :number
      t.boolean :checked_in

      t.timestamps
    end
    add_index :customers, :number
  end
end
