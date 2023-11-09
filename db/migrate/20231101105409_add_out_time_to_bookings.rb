class AddOutTimeToBookings < ActiveRecord::Migration[7.1]
  def change
    add_column :bookings, :out_time, :datetime
  end
end
