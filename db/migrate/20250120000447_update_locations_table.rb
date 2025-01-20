class UpdateLocationsTable < ActiveRecord::Migration[8.0]
  def change
    remove_column :locations, :postal_code, :string
    change_column_null :locations, :latitude, false
    change_column_null :locations, :longitude, false
  end
end
