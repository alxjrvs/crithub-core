class AddDynamicToMod < ActiveRecord::Migration[5.0]
  def change
    add_column :mods, :dynamic, :boolean, default: false
  end
end
