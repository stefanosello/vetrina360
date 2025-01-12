class CreateTenants < ActiveRecord::Migration[8.0]
  def change
    create_table :tenants do |t|
      t.string :slug
      t.string :name
      t.jsonb :additional_info
      t.datetime :discarded_at, index: true
      t.integer :lock_version, default: 0, null: false

      t.timestamps
    end
  end
end
