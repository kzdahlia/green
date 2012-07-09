class CreateTaggings < ActiveRecord::Migration
  def change
    create_table :taggings do |t|
      t.integer :tag_id
      t.integer :foto_id
      t.integer :user_id
      t.timestamps
    end
    add_index :taggings, [:tag_id]
    add_index :taggings, [:user_id]
    add_index :taggings, [:tag_id, :foto_id], :unique => true
  end
end
