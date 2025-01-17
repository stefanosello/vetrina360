class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :description
      t.string :additional_description
      t.string :model
      t.datetime :discarded_at
      t.integer :lock_version

      t.timestamps
    end
  end
end
