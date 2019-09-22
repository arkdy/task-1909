class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.references :timezone
      t.timestamps(default: -> { "CURRENT_TIMESTAMP" })
    end

    add_index :users, :name, unique: true
  end
end
