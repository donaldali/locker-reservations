class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.string     :number
      t.references :customer

      t.timestamps
    end
    add_index :reservations, :number
    add_index :reservations, :customer_id
  end
end
