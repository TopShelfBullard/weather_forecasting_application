class CreateLocations < ActiveRecord::Migration[8.0]
  def change
    create_table :locations do |t|
      t.string :title
      t.string :latitude
      t.string :longitude
      t.string :postal_code

      t.timestamps
    end
  end
end
