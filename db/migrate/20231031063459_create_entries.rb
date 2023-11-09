class CreateEntries < ActiveRecord::Migration[7.1]
  def change
    create_table :entries do |t|
      t.float :lat
      t.float :lon

      t.timestamps
    end
  end
end
