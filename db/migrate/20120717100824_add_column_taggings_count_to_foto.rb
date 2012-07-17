class AddColumnTaggingsCountToFoto < ActiveRecord::Migration
  def change
    add_column :fotos, :taggings_count, :integer, :default => 0, :after => :file
  end
end
