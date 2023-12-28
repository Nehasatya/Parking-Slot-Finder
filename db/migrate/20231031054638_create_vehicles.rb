class CreateVehicles < ActiveRecord::Migration[7.1]
  def change
    create_table :vehicles do |t|
      t.string :reg_no
      t.datetime :first_entry_time

      t.timestamps
    end
  end
end
