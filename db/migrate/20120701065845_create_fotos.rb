class CreateFotos < ActiveRecord::Migration
  def change
    create_table :fotos do |t|
      t.integer :user_id
      t.string :url
      t.datetime :datetime
      t.integer :width
      t.integer :height
      t.string :file
      t.string :fetch_state
      t.string :url_thumb
      t.text :data
      t.timestamps
    end
  end
end
