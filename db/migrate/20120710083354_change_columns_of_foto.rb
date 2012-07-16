class ChangeColumnsOfFoto < ActiveRecord::Migration
  def up
    add_index :fotos, :user_id
    add_column :fotos, :token, :string, :after => :user_id
    add_index :fotos, :token
  end

  def down
  end
end
