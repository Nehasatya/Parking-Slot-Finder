class AddDistanceFromEntryPoint3ToSlot < ActiveRecord::Migration[7.1]
  def change
    add_column :slots, :distance_from_entry_point_3, :float
  end
end
