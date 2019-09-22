class CreateTimezones < ActiveRecord::Migration[5.2]
  def change
    create_table :timezones do |t|
      t.string :name, null: false
      t.integer :world_region, null: false

      t.timestamps
    end
    add_index :timezones, :name, unique: true
  end
end
