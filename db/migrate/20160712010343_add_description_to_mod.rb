class AddDescriptionToMod < ActiveRecord::Migration[5.0]
  def change
    add_column :mods, :description, :text
  end
end
