class CreateMod < ActiveRecord::Migration[5.0]
  def change
    create_table :mods do |t|
      t.belongs_to :character, required: true
      t.string :modifier, required: true 
      t.string :value
      t.string :memo
    end
  end
end
