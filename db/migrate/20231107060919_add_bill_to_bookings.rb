class AddBillToBookings < ActiveRecord::Migration[7.1]
  def change
    add_column :bookings, :bill, :float
  end
end
