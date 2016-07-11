class RenameClassToClassName < ActiveRecord::Migration[5.0]
  def change
    rename_column :levels, :class, :class_name
  end
end
