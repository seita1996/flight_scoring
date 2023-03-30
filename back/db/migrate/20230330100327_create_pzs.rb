class CreatePzs < ActiveRecord::Migration[7.0]
  def change
    create_table :pzs do |t|
      t.references :area, null: false, foreign_key: true
      t.integer :type, null: false
      t.string :name, null: false
      t.integer :radius
      t.integer :altitude

      t.timestamps
    end
  end
end
