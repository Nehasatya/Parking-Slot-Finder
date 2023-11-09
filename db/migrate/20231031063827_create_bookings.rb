class CreateBookings < ActiveRecord::Migration[7.1]
  def change
    create_table :bookings do |t|
      t.references :vehicle, null: false, foreign_key: true
      t.references :slot, null: false, foreign_key: true
      t.datetime :in_time

      t.timestamps
    end
  end
end
