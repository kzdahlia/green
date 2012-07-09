class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :name
      t.integer :user_id
      t.integer :tagging_count, :default => 0
      t.timestamps
    end
    add_index :tags, [:name, :user_id]
    add_index :tags, [:user_id]
  end
end
