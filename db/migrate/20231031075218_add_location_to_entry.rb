class AddLocationToEntry < ActiveRecord::Migration[7.1]
  def change
    add_column :entries, :location, :string
  end
end
