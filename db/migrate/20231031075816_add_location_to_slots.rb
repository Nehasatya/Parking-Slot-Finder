class AddLocationToSlots < ActiveRecord::Migration[7.1]
  def change
    add_column :slots, :location, :string
  end
end
