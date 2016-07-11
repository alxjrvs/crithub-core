class CreateLevel < ActiveRecord::Migration[5.0]
  def change
    create_table :levels do |t|
      t.belongs_to :character, null: false
      t.integer :number, null: false
      t.string :class, null: false
    end
  end
end
