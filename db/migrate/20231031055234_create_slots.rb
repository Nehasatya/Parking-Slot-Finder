class CreateSlots < ActiveRecord::Migration[7.1]
  def change
    create_table :slots do |t|
      t.float :lat
      t.float :lon
      t.string :status

      t.timestamps
    end
  end
end
