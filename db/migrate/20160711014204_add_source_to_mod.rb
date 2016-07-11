class AddSourceToMod < ActiveRecord::Migration[5.0]
  def change
    add_column :mods, :source, :string, required: true
  end
end
